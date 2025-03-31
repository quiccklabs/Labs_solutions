


export REGION=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-region])")

export ZONE=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-zone])")


PROJECT_ID=`gcloud config get-value project`

export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")



export GCLOUD_PROJECT=$PROJECT_ID
export GCLOUD_LOCATION=$REGION



mkdir genkit-intro && cd genkit-intro
npm init -y

npm install -D genkit-cli@1.0.4

npm install genkit@1.0.4 --save
npm install @genkit-ai/vertexai@1.0.4 @genkit-ai/google-cloud@1.0.4 @genkit-ai/express@1.0.4 --save

mkdir src && touch src/index.ts


cat > src/index.ts <<EOF_END
import { z, genkit } from 'genkit';
import { vertexAI } from '@genkit-ai/vertexai';
import { gemini15Flash } from '@genkit-ai/vertexai';
import { logger } from 'genkit/logging';
import { enableGoogleCloudTelemetry } from '@genkit-ai/google-cloud';
import { startFlowServer } from '@genkit-ai/express';

const ai = genkit({
    plugins: [
        vertexAI({ location: '$REGION'}),
    ]
});

logger.setLogLevel('debug');
enableGoogleCloudTelemetry();
EOF_END


gcloud storage cp ~/genkit-intro/package.json gs://$PROJECT_ID
gcloud storage cp ~/genkit-intro/src/index.ts gs://$PROJECT_ID


#Task 2

mkdir ~/genkit-intro/data

cat <<EOF > ~/genkit-intro/data/menu.json
[
    {
        "title": "Mozzarella Sticks",
        "price": 8,
        "description": "Crispy fried mozzarella sticks served with marinara sauce."
    },
    {
        "title": "Chicken Wings",
        "price": 10,
        "description": "Crispy fried chicken wings tossed in your choice of sauce."
    },
    {
    "title": "Nachos",
        "price": 12,
        "description": "Crispy tortilla chips topped with melted cheese, chili, sour cream, and salsa."
    },
    {
        "title": "Onion Rings",
        "price": 7,
        "description": "Crispy fried onion rings served with ranch dressing."
    },
    {
        "title": "French Fries",
        "price": 5,
        "description": "Crispy fried french fries."
    },
    {
        "title": "Mashed Potatoes",
        "price": 6,
        "description": "Creamy mashed potatoes."
    },
    {
        "title": "Coleslaw",
        "price": 4,
        "description": "Homemade coleslaw."
    },
    {
        "title": "Classic Cheeseburger",
        "price": 12,
        "description": "A juicy beef patty topped with melted American cheese, lettuce, tomato, and onion on a toasted bun."
    },
    {
        "title": "Bacon Cheeseburger",
        "price": 14,
        "description": "A classic cheeseburger with the addition of crispy bacon."
    },
    {
        "title": "Mushroom Swiss Burger",
        "price": 15,
        "description": "A beef patty topped with sautéed mushrooms, melted Swiss cheese, and a creamy horseradish sauce."
    },
    {
        "title": "Chicken Sandwich",
        "price": 13,
        "description": "A crispy chicken breast on a toasted bun with lettuce, tomato, and your choice of sauce."
    },
    {
        "title": "Pulled Pork Sandwich",
        "price": 14,
        "description": "Slow-cooked pulled pork on a toasted bun with coleslaw and barbecue sauce."
    },
    {
        "title": "Reuben Sandwich",
        "price": 15,
        "description": "Thinly sliced corned beef, Swiss cheese, sauerkraut, and Thousand Island dressing on rye bread."
    },
    {
        "title": "House Salad",
        "price": 8,
        "description": "Mixed greens with your choice of dressing."
    },
    {
        "title": "Caesar Salad",
        "price": 9,
        "description": "Romaine lettuce with croutons, Parmesan cheese, and Caesar dressing."
    },
    {
        "title": "Greek Salad",
        "price": 10,
        "description": "Mixed greens with feta cheese, olives, tomatoes, cucumbers, and red onions."
    },
    {
        "title": "Chocolate Lava Cake",
        "price": 8,
        "description": "A warm, gooey chocolate cake with a molten chocolate center."
    },
    {
        "title": "Apple Pie",
        "price": 7,
        "description": "A classic apple pie with a flaky crust and warm apple filling."
    },
    {
        "title": "Cheesecake",
        "price": 8,
        "description": "A creamy cheesecake with a graham cracker crust."
    }
]
EOF



cat > src/index.ts <<'EOF_END'
import { z, genkit } from 'genkit';
import { vertexAI } from '@genkit-ai/vertexai';
import { gemini15Flash } from '@genkit-ai/vertexai';
import { logger } from 'genkit/logging';
import { enableGoogleCloudTelemetry } from '@genkit-ai/google-cloud';
import { startFlowServer } from '@genkit-ai/express';

const ai = genkit({
    plugins: [
        vertexAI({ location: '$REGION'}),
    ]
});

logger.setLogLevel('debug');
enableGoogleCloudTelemetry();

export const MenuItemSchema = z.object({
    title: z.string()
        .describe('The name of the menu item'),
    description: z.string()
        .describe('Details, including ingredients and preparation'),
    price: z.number()
        .describe('Price, in dollars'),
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



const menuData: Array<MenuItem> = require('../data/menu.json')

export const menuTool = ai.defineTool(
{
    name: 'todaysMenu',
    description: "Use this tool to retrieve all the items on today's menu",
    inputSchema: z.object({}),
    outputSchema: z.object({
        menuData: z.array(MenuItemSchema)
            .describe('A list of all the items on the menu'),
    }),
},
async () => Promise.resolve({ menuData: menuData })
);



export const dataMenuPrompt = ai.definePrompt(
{
    name: 'dataMenu',
    model: gemini15Flash,
    input: { schema: MenuQuestionInputSchema },
    output: { format: 'text' },
    tools: [menuTool],
},
`
You are acting as a helpful AI assistant named Walt that can answer
questions about the food available on the menu at Walt's Burgers.

Answer this customer's question, in a concise and helpful manner,
as long as it is about food on the menu or something harmless like sports.
Use the tools available to answer food and menu questions.
DO NOT INVENT ITEMS NOT ON THE MENU.

Question:
{{question}} ?
`
);


export const menuQuestionFlow = ai.defineFlow(
{
    name: 'menuQuestion',
    inputSchema: MenuQuestionInputSchema,
    outputSchema: AnswerOutputSchema,
},
async (input) => {
    const response = await dataMenuPrompt({
        question: input.question,
    });
    return { answer: response.text };
}
);



startFlowServer({
    flows: [menuQuestionFlow],
    port: 8080,
    cors: {
        origin: '*',
    },
});


EOF_END


sed -i "s/'\$REGION'/\"$REGION\"/g" src/index.ts

gcloud storage cp -r ~/genkit-intro/data/menu.json gs://$PROJECT_ID
gcloud storage cp -r ~/genkit-intro/src/index.ts gs://$PROJECT_ID

cd ~/genkit-intro
npx genkit start -- npx tsx src/index.ts | tee -a output.txt
