import streamlit as st
from vertexai.preview.generative_models import GenerativeModel, Part
from response_utils import *
import logging

# render the Video Playground tab with multiple child tabs
def render_video_playground_tab(multimodal_model_pro: GenerativeModel):

    st.write("Using Gemini 1.0 Pro Vision - Multimodal model")
    video_desc, video_tags, video_highlights, video_geoloc = st.tabs(["Video description", "Video tags", "Video highlights", "Video geolocation"])

    with video_desc:
        video_desc_uri = "gs://cloud-training/OCBL447/gemini-app/videos/mediterraneansea.mp4"
        video_desc_url = "https://storage.googleapis.com/"+video_desc_uri.split("gs://")[1]            

        video_desc_vid = Part.from_uri(video_desc_uri, mime_type="video/mp4")
        st.video(video_desc_url)
        st.write("Generate a description of the video.")

        prompt = """Describe what is happening in the video and answer the following questions: \n
                - What am I looking at?
                - Where should I go to see it?
                - What are other top 5 places in the world that look like this? 
                """

        tab1, tab2 = st.tabs(["Response", "Prompt"])
        video_desc_description = st.button("Generate video description", key="video_desc_description")
        with tab1:
            if video_desc_description and prompt: 
                with st.spinner("Generating video description"):
                    response = get_gemini_pro_vision_response(multimodal_model_pro, [prompt, video_desc_vid])
                    st.markdown(response)
                    logging.info(response)
        with tab2:
            st.write("Prompt used:")
            st.write(prompt,"\n","{video_data}")


    with video_tags:
        video_tags_uri = "gs://cloud-training/OCBL447/gemini-app/videos/photography.mp4"
        video_tags_url = "https://storage.googleapis.com/"+video_tags_uri.split("gs://")[1]

        video_tags_vid = Part.from_uri(video_tags_uri, mime_type="video/mp4")
        st.video(video_tags_url)
        st.write("Generate tags for the video.")

        prompt = """Answer the following questions using the video only:
                    1. What is in the video?
                    2. What objects are in the video?
                    3. What is the action in the video?
                    4. Provide 5 best tags for this video?
                    Write the answer in table format with the questions and answers in columns.
                """

        tab1, tab2 = st.tabs(["Response", "Prompt"])
        video_tags_desc = st.button("Generate video tags", key="video_tags_desc")
        with tab1:
            if video_tags_desc and prompt: 
                with st.spinner("Generating video tags"):
                    response = get_gemini_pro_vision_response(multimodal_model_pro, [prompt, video_tags_vid])
                    st.markdown(response)
                    logging.info(response)
        with tab2:
            st.write("Prompt used:")
            st.write(prompt,"\n","{video_data}")


    with video_highlights:
        video_highlights_uri = "gs://cloud-training/OCBL447/gemini-app/videos/pixel8.mp4"
        video_highlights_url = "https://storage.googleapis.com/"+video_highlights_uri.split("gs://")[1]

        video_highlights_vid = Part.from_uri(video_highlights_uri, mime_type="video/mp4")
        st.video(video_highlights_url)
        st.write("Generate highlights for the video.")

        prompt = """Answer the following questions using the video only:
                What is the profession of the girl in this video?
                Which features of the phone are highlighted here?
                Summarize the video in one paragraph.
                Write these questions and their answers in table format. 
                """

        tab1, tab2 = st.tabs(["Response", "Prompt"])
        video_highlights_description = st.button("Generate video highlights", key="video_highlights_description")
        with tab1:
            if video_highlights_description and prompt: 
                with st.spinner("Generating video highlights"):
                    response = get_gemini_pro_vision_response(multimodal_model_pro, [prompt, video_highlights_vid])
                    st.markdown(response)
                    logging.info(response)
        with tab2:
            st.write("Prompt used:")
            st.write(prompt,"\n","{video_data}")


    with video_geoloc:
        video_geolocation_uri = "gs://cloud-training/OCBL447/gemini-app/videos/bus.mp4"
        video_geolocation_url = "https://storage.googleapis.com/"+video_geolocation_uri.split("gs://")[1]

        video_geolocation_vid = Part.from_uri(video_geolocation_uri, mime_type="video/mp4")
        st.video(video_geolocation_url)
        st.markdown("""Answer the following questions from the video:
                    - What is this video about?
                    - How do you know which city it is?
                    - What street is this?
                    - What is the nearest intersection?
                    """)

        prompt = """Answer the following questions using the video only:
                What is this video about?
                How do you know which city it is?
                What street is this?
                What is the nearest intersection?
                Answer the following questions using a table format with the questions and answers as columns. 
                """

        tab1, tab2 = st.tabs(["Response", "Prompt"])
        video_geolocation_description = st.button("Generate", key="video_geolocation_description")
        with tab1:
            if video_geolocation_description and prompt: 
                with st.spinner("Generating location information"):
                    response = get_gemini_pro_vision_response(multimodal_model_pro, [prompt, video_geolocation_vid])
                    st.markdown(response)
                    logging.info(response)
        with tab2:
            st.write("Prompt used:")
            st.write(prompt,"\n","{video_data}")

