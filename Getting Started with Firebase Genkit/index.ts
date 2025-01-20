import { z, genkit } from 'genkit';
import { vertexAI } from '@genkit-ai/vertexai';
import { gemini15Flash } from '@genkit-ai/vertexai';
import { logger } from 'genkit/logging';
import { enableGoogleCloudTelemetry } from '@genkit-ai/google-cloud';


const ai = genkit({
    plugins: [
        vertexAI({ location: 'us-east1'}),
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
        // Construct a request and send it to the model API.
        const llmResponse = await ai.generate({
            prompt: `Suggest an item for the menu of a ${subject} themed restaurant`,
            model: gemini15Flash,
            config: {
                temperature: 1,
            },
        });
    
        // Handle the response from the model API. In this sample, we just convert
        // it to a string, but more complicated flows might coerce the response into
        // structured output or chain the response into another LLM call, etc.
        return llmResponse.text;
    }
    );

export const jokeFlow = ai.defineFlow(
{
    name: 'jokeFlow',
    inputSchema: z.string(),
    outputSchema: z.string(),
},
async (subject) => {
    const llmResponse = await ai.generate({
        prompt: `Tell me a joke about ${subject}`,
        model: gemini15Flash,
        config: {
            temperature: 1,
        },
    });

    return llmResponse.text;
}
);


const CustomerTimeAndHistorySchema = z.object({
    customerName: z.string(),
    currentTime: z.string(),
    previousOrder: z.string(),
});


const greetingWithHistoryPrompt = ai.definePrompt(
{
    name: 'greetingWithHistory',
    model: gemini15Flash,
    input: { schema: CustomerTimeAndHistorySchema },
    output: {
        format: 'text',
    },
},
`
{{role "user"}}
Hi, my name is {{customerName}}. The time is {{currentTime}}. Who are you?
{{role "model"}}
I am Barb, a barista at this nice underwater-themed coffee shop called Krabby Kooffee.
I know pretty much everything there is to know about coffee,
and I can cheerfully recommend delicious coffee drinks to you based on whatever you like.
{{role "user"}}
Great. Last time I had {{previousOrder}}.
I want you to greet me in one sentence, and recommend a drink.
`
);


export const greetingFlow = ai.defineFlow(
{
    name: 'greetingFlow',
    inputSchema: CustomerTimeAndHistorySchema,
    outputSchema: z.string(),
},
async (input) => {
    const response  = await greetingWithHistoryPrompt({
        customerName: input.customerName,
        currentTime: input.currentTime,
        previousOrder: input.previousOrder
    });
    return response.text;
}
);

ai.startFlowServer({
    flows: [menuSuggestionFlow, jokeFlow, greetingFlow],
});