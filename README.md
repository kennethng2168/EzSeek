# EzSeek: Smart Online Shop System
## Overview
An AI shop assistance with the idea of Multimodal RAG product search, virtual try-on on product like clothes and the promote of ESG and SDG product for enviroment purpose.


## Features and Functionality

Videos | Features & Functionality | Assets/APIs Used
:-------------------------:|:-------------------------:|:-------------------------:
[Virtual Try On](Videos/Virtual_Try_on.mp4) | Description of Virtual Try On feature | Relevant APIs or assets
[ESG Rewards Stable Diffusion](Videos/ESG_Rewards_Stable_Diffusion.mp4) | Description of ESG Rewards feature | Relevant APIs or assets
[RAG](Videos/RAG.mp4) | Description of RAG feature | Relevant APIs or assets
[TikTok Player OEmbed](Videos/TikTok_player_OEmbed.mp4) | Description of TikTok Player OEmbed feature | Relevant APIs or assets


### Development Tools
Python 

Fast

Flutter
### APIs Used
Oembed API

Gemini AI API - used to develop the multimodal retrieval-augmented generation (RAG) with the gemini lastest api model - gemini flash with the ability to read image and text. 

### Assets Used
Custom icons and graphics designed using TikTok

### Libraries Used
flutter all packages + python all packages

Pandas- to read and preprocess the data

Google-text-embedding model to embed the product data into a FAISS vector database for the RAG product search

LangChain- Used to develop multimodal RAG AI model which can based on the user picture condition and text prompt to suggest product for the user. 

## Problem Statement
Wait to add

## Installation and Setup
Clone the repository:

### Copy code
git clone https://github.com/kennethng2168/EzSeek


### Install dependencies:
pip install -r requirements.txt

### Usage
Install the ckpt file from [Google Drive](https://drive.google.com/drive/folders/19DvmOfsvnP8m6WpPkYe2AJYmiH4ROzvn?usp=sharing)
Run the backend server:
python app.py




## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Team Background
Kenneth Ng - Computer engineering

Teh Chen Ming - Computer science specialism in data analyst 

Lau Yi Jing  - Electrical and Electronic Engineering 

## Acknowledgements
Special thanks to our mentors and advisors.

Thanks to (https://www.kaggle.com/datasets/devi5723/e-commerce-cosmetics-dataset) for providing the sample data.

Thanks to stable diffusion model in hugging face and opensource model IDM-VTON

Thanks to our mentor Dr. Lau
