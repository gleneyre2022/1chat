# 1chat

![1chat_image](/doc/assets/1chat_en.jpg)

[English](readme.md) | [中文](readme_cn.md)

1chat is an iOS app that lets you chat with the DeepSeek-R1 model locally.

Designed with privacy and security in mind, 1chat requires no internet connection or special permissions. It runs entirely on-device with an integrated model, ready to use right out of the box.

1chat is based on the open-source project [fullmoon-ios](https://github.com/mainframecomputer/fullmoon-ios), with custom development and integration of the DeepSeek-R1-Distill-Qwen-1.5B model.

It is fully compatible with DeepSeek R1 and supports deep thinking (DeepThink).

You can download 1chat from [App Store](https://apps.apple.com/us/app/id6741682608)

1chat can run on iPhone, iPad, Mac, and Vision Pro.

# Features

* Built-in DeepSeek-R1 model(qwen-q4-1.5b), ready to use.
* Runs entirely offline—no internet required.
* Fully adapted for the R1 model.
* Supports multiple conversation management.
* Optimized for Apple chips.

# Differences from fullmoon

1. Removed the [system prompt](https://github.com/deepseek-ai/DeepSeek-R1?tab=readme-ov-file#usage-recommendations)(temporarily).
2. Localize for Chinese.
3. Removed the model downloader.
4. Currently supports only DeepSeek-R1 (temporarily).

# How to build

### Clone the repository

`git clone https://github.com/OJZen/1chat.git`

### Download the model

Download DeepSeek-R1 model files from [huggingface](https://huggingface.co/mlx-community/deepseek-r1-distill-qwen-1.5b) 

Alternatively, you can use another model, but it must meet these requirements:

1. It must be a DeepSeek-R1 distill model.
2. It must be in MLX format.

The 1.5B model work best on my iPhone 15 pro -- it's fast enough for smooth performance.

### Place the model

Place all model files into the [model folder](model).

### Xcode, launch!

Open the 1chat project in Xcode, then build and run.

# Known issues

DeepSeek-R1 currently has an annoying issue where the output sometimes repeats endlessly.

I don’t know how to fix it, so for now, I’ve added a method that automatically truncates the output when repetition is detected.