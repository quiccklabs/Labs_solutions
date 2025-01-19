import { z, genkit } from 'genkit';
import { vertexAI } from '@genkit-ai/vertexai';
import { gemini15Flash } from '@genkit-ai/vertexai';
import { textEmbedding004 } from '@genkit-ai/vertexai';
import { Document, index, retrieve } from '@genkit-ai/ai/retriever';
import { devLocalIndexerRef, devLocalRetrieverRef, devLocalVectorstore } from '@genkit-ai/dev-local-vectorstore';
import { logger } from 'genkit/logging';
import { enableGoogleCloudTelemetry } from '@genkit-ai/google-cloud';
import { GenkitMetric, genkitEval } from '@genkit-ai/evaluator';

// const ai = genkit({
//     plugins: [
//         vertexAI({ location: 'us-west1' }),
//         devLocalVectorstore([
//         {
//             indexName: 'menu-items',
//             embedder: textEmbedding004,
//             embedderOptions: { taskType: 'RETRIEVAL_DOCUMENT' },
//         }
//         ]),
//     ]
//   });

//   logger.setLogLevel('debug');
//   enableGoogleCloudTelemetry();



  const ai = genkit({
    plugins: [
        vertexAI({ location: 'us-west1' }),
        devLocalVectorstore([
        {
            indexName: 'menu-items',
            embedder: textEmbedding004,
            embedderOptions: { taskType: 'RETRIEVAL_DOCUMENT' },
        }
        ]),
        genkitEval({
            judge: gemini15Flash,
            metrics: [GenkitMetric.FAITHFULNESS, GenkitMetric.ANSWER_RELEVANCY],
            embedder: textEmbedding004, // GenkitMetric.ANSWER_RELEVANCY requires an embedder
          }),
    ]
  });

  logger.setLogLevel('debug');
  enableGoogleCloudTelemetry();




export const menuSuggestionFlow = ai.defineFlow(
{
  name: 'menuSuggestionFlow',
  inputSchema: z.string(),
  outputSchema: z.string(),
},
async (subject) => {
  const llmResponse = await ai.generate({
    prompt: `Suggest an item for the menu of a ${subject} themed restaurant`,
    model: gemini15Flash,
    config: {
      temperature: 1,
    },
  });

  return llmResponse.text;
}
);



export const MenuItemSchema = z.object({
  title: z.string()
    .describe('The name of the menu item'),
  description: z.string()
    .describe('Details including ingredients and preparation'),
  price: z.number()
    .describe('Price in dollars'),
});

export type MenuItem = z.infer<typeof MenuItemSchema>;

// Input schema for a question about the menu
export const MenuQuestionInputSchema = z.object({
    question: z.string(),
});

// Output schema containing an answer to a question
export const AnswerOutputSchema = z.object({
  answer: z.string(),
});

// Input schema for a question about the menu where the menu is provided in JSON data
export const DataMenuQuestionInputSchema = z.object({
  menuData: z.array(MenuItemSchema),
  question: z.string(),
});

// Input schema for a question about the menu where the menu is provided as unstructured text
export const TextMenuQuestionInputSchema = z.object({
  menuText: z.string(),
  question: z.string(),
});


export const ragDataMenuPrompt = ai.definePrompt(
{
    name: 'ragDataMenu',
    model: gemini15Flash,
    input: { schema: DataMenuQuestionInputSchema },
    output: { format: 'text' },
    config: { temperature: 0.3 },
},
`
You are acting as Walt, a helpful AI assistant here at the restaurant.
You can answer questions about the food on the menu or any other questions customers have about food in general.

Here are some items that are on today's menu that are relevant to helping you answer the customer's question:
{{#each menuData~}}
-	{{this.title}} \${{this.price}}
    {{this.description}}
    {{~/each}}

Answer this customer's question:
{{question}}?
`
);


export const ragMenuQuestionFlow = ai.defineFlow(
{
  name: 'ragMenuQuestion',
  inputSchema: MenuQuestionInputSchema,
  outputSchema: AnswerOutputSchema,
},
async (input) => {
  // Retrieve the 3 most relevant menu items for the question
  const docs = await ai.retrieve({
    retriever: devLocalRetrieverRef('menu-items'),
    query: input.question,
    options: { k: 3 },
  });

  const menuData: Array<MenuItem> = docs.map(
    (doc) => (doc.metadata || {}) as MenuItem
  );

  // Generate the response
  const response = await ragDataMenuPrompt({
        menuData: menuData,
        question: input.question,
  });

  return { answer: response.text };
}
);



export const indexMenuItemsFlow = ai.defineFlow(
  {
    name: 'indexMenuItems',
    inputSchema: z.array(MenuItemSchema),
    outputSchema: z.object({ rows: z.number() }),
  },
  async (menuItems) => {
    // Store each document with its text indexed,
    // and its original JSON data as its metadata.
    const documents = menuItems.map((menuItem) => {
      const text = `${menuItem.title} ${menuItem.price} \n ${menuItem.description}`;
      return Document.fromText(text, menuItem);
    });
    await ai.index({
      indexer: devLocalIndexerRef('menu-items'),
      documents,
    });
    return { rows: menuItems.length };
  }
);


ai.startFlowServer({
    flows: [menuSuggestionFlow, ragMenuQuestionFlow, indexMenuItemsFlow],
    port: 8080,
    cors: {
        origin: '*',
    },
});

