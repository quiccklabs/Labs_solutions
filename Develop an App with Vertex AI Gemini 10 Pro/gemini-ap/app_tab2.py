import streamlit as st
from vertexai.preview.generative_models import GenerativeModel
from response_utils import *
import logging

# create the model prompt based on user input.
def generate_prompt():
    st.write("Using Gemini 1.0 Pro - Text only model")
    st.subheader("Generate your marketing campaign")

    product_name = st.text_input("What is the name of the product? \n\n",key="product_name",value="ZomZoo")
    product_category = st.radio("Select your product category: \n\n",["Clothing","Electronics","Food","Health & Beauty","Home & Garden"],key="product_category",horizontal=True)

    st.write("Select your target audience: ")
    target_audience_age = st.radio("Target age: \n\n",["18-24","25-34","35-44","45-54","55-64","65+"],key="target_audience_age",horizontal=True)
    # target_audience_gender = st.radio("Target gender: \n\n",["male","female","trans","non-binary","others"],key="target_audience_gender",horizontal=True)
    target_audience_location = st.radio("Target location: \n\n",["Urban", "Suburban","Rural"],key="target_audience_location",horizontal=True)

    st.write("Select your marketing campaign goal: ")
    campaign_goal = st.multiselect("Select your marketing campaign goal: \n\n",["Increase brand awareness","Generate leads","Drive sales","Improve brand sentiment"],key="campaign_goal",default=["Increase brand awareness","Generate leads"])
    if campaign_goal is None:
        campaign_goal = ["Increase brand awareness","Generate leads"]
    brand_voice = st.radio("Select your brand voice: \n\n",["Formal","Informal","Serious","Humorous"],key="brand_voice",horizontal=True)
    estimated_budget = st.radio("Select your estimated budget ($): \n\n",["1,000-5,000","5,000-10,000","10,000-20,000","20,000+"],key="estimated_budget",horizontal=True)

    prompt = f"""Generate a marketing campaign for {product_name}, a {product_category} designed for the age group: {target_audience_age}. 
    The target location is this: {target_audience_location}.
    Aim to primarily achieve {campaign_goal}. 
    Emphasize the product's unique selling proposition while using a {brand_voice} tone of voice. 
    Allocate the total budget of {estimated_budget}.  
    With these inputs, make sure to follow following guidelines and generate the marketing campaign with proper headlines: \n
    - Briefly describe the company, its values, mission, and target audience.
    - Highlight any relevant brand guidelines or messaging frameworks.
    - Provide a concise overview of the campaign's objectives and goals.
    - Briefly explain the product or service being promoted.
    - Define your ideal customer with clear demographics, psychographics, and behavioral insights.
    - Understand their needs, wants, motivations, and pain points.
    - Clearly articulate the desired outcomes for the campaign.
    - Use SMART goals (Specific, Measurable, Achievable, Relevant, and Time-bound) for clarity.
    - Define key performance indicators (KPIs) to track progress and success.
    - Specify the primary and secondary goals of the campaign.
    - Examples include brand awareness, lead generation, sales growth, or website traffic.
    - Clearly define what differentiates your product or service from competitors.
    - Emphasize the value proposition and unique benefits offered to the target audience.
    - Define the desired tone and personality of the campaign messaging.
    - Identify the specific channels you will use to reach your target audience.
    - Clearly state the desired action you want the audience to take.
    - Make it specific, compelling, and easy to understand.
    - Identify and analyze your key competitors in the market.
    - Understand their strengths and weaknesses, target audience, and marketing strategies.
    - Develop a differentiation strategy to stand out from the competition.
    - Define how you will track the success of the campaign.
    - Use relevant KPIs to measure performance and return on investment (ROI).
    Provide bullet points and headlines for the marketing campaign. Do not produce any empty lines. Be very succinct and to the point.
    """

    return prompt

# function to render the story tab, and call the model, and display the model prompt and response.
def render_mktg_campaign_tab (text_model_pro: GenerativeModel):
    st.write("Using Gemini 1.0 Pro - Text only model")
    st.subheader("Generate a marketing campaign")

    prompt = generate_prompt()

    config = {
        "temperature": 0.8,
        "max_output_tokens": 2048,
        }

    generate_t2m = st.button("Generate campaign", key="generate_t2m")
    if generate_t2m and prompt:
        # st.write(prompt)
        with st.spinner("Generating a marketing campaign using Gemini..."):
            first_tab1, first_tab2 = st.tabs(["Campaign response", "Prompt"])
            with first_tab1: 
                response = get_gemini_pro_text_response(text_model_pro, prompt, generation_config=config)
                if response:
                    st.write("Marketing campaign:")
                    st.write(response)
                    logging.info(response)
            with first_tab2: 
                st.text(prompt)

