# EzSeek: Simplify Shopping with GenAI for productivity and promoting ESG


## Overview
EzSeek is an AI-driven online shopping assistance system that leverages Multimodal Retrieval-Augmented Generation (RAG) for advanced product search and virtual try-on features. The system also promotes products aligned with Environmental, Social, and Governance (ESG) goals and Sustainable Development Goals (SDG) by using AI-Generated Images (Stable Diffusion) to support environmental sustainability.

## Development Tools
- Flutter (IOS/Android)
- Python

## Features and Functionality
Download videos to view the functionalities and features
| Videos | Features & Functionality | Assets/APIs Used |
|:-------:|:-------------------------:|:-----------------:|
| [Virtual Try On](Videos/Virtual_Try_on.mp4) | Experience virtual try-on for clothing products. | IDM-VTON opensource |
| [ESG Rewards Stable Diffusion](Videos/ESG_Rewards_Stable_Diffusion.mp4) | Showcase how our system promotes ESG and SDG products to redeem rewards after purchasing or scroll the content up to specific hours | huggingface stable-diffusion-xl-base-1.0 and White TikTok Horizontal Logo Assets |
| [RAG](Videos/RAG.mp4) | Demonstrate the Multimodal RAG product search functionality. | Gemini API |
| [TikTok Player OEmbed](Videos/TikTok_player_OEmbed.mp4) | Integration with TikTok Player OEmbed feature. | TikTok Official API OEmbed with author URL and TikTok Player |

### Development Tools
- **Python**: For backend development.
- **FastAPI**: For building the API.
- **Flutter**: For frontend development.

### APIs Used
- **Oembed API**: For embedding and integrating content for TikTok Player in main screen and TikTok auth Url using Oembed API.
- **Gemini AI API**: Utilized for developing the Multimodal Retrieval-Augmented Generation (RAG) model, including the latest Gemini Flash model capable of processing both image and text inputs.

### Assets Used
- **Custom Icons and Graphics**: Designed using TikTok logo horizontal logo

### Libraries Used
- **Flutter Packages**: Various packages for Flutter development in pubspec.yaml
- **Python Packages**: Various packages for Python development.
  - **Pandas**: For reading and preprocessing data.
  - **Google Text Embedding Model**: To embed product data into a FAISS vector database for RAG-based product search.
  - **LangChain**: Used for developing the multimodal RAG AI model, which suggests products based on user image conditions and text prompts.

## Problem Statement
Track 2: Problem Statement on Inspiring Creativity with Generative AI. (Malaysia)
In the scenario of creating and consuming streaming media content, generative AI technologies can be utilized for content optimization, information extraction, and style transformation, to refine content across various media platforms. With these technologies, we can cater to the preferences of diverse audiences, as well as facilitate creators in producing higher-quality content more efficiently.

Productivity with Multimodal and LLM RAG
Text-to-Image,
Images-to-Images
## Installation and Setup for FastAPI to interact with Mobile App
### Download Weights ckpt and Replace with the Backend/VirtualTryOn-OpenSource/ckpt
[Download Here](https://drive.google.com/drive/folders/19DvmOfsvnP8m6WpPkYe2AJYmiH4ROzvn?usp=sharing)

### For RAG
```bash
cd EzSeek/Backend/RAG
export GOOGLE_API_KEY=xxx
python3 server_llm.py
```
### For Stable Diffusion
```bash
cd EzSeek/Backend/StableDiffusion
python3 server_stable diffusion.py
```

### For Virual Try On
```bash
cd EzSeek/Backend/VirtualTryOn-OpenSource
python3 server_fastapi.py
```

### For Frontend Flutter
```bash
cd EzSeek/FrontEnd
Run the pubspec.yaml
run main.dart
```

### Clone the Repository
```bash
git clone https://github.com/kennethng2168/EzSeek
```
