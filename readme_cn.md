# 1chat  

![1chat_image](/doc/assets/1chat_cn.jpg)

[English](readme.md) | [中文](readme_cn.md)

1chat 是一款 iOS 应用，可以在本地与 DeepSeek-R1 模型进行对话。  

1chat 注重隐私和安全性，无需联网或额外权限。应用完全在设备上运行，内置模型，开箱即用。  

1chat 基于开源项目 [fullmoon-ios](https://github.com/mainframecomputer/fullmoon-ios) 开发，并集成了 DeepSeek-R1-Distill-Qwen-1.5B 模型，完全兼容 DeepSeek-R1，并支持深度思考（DeepThink）。  

你可以从 [App Store](https://apps.apple.com/us/app/id6741682608) 下载 1chat。  

1chat 能够在 iPhone、iPad、Mac 以及 Vision Pro 上运行。

## 功能特点  

- 内置 DeepSeek-R1 模型（qwen-q4-1.5B），即装即用。  
- 完全离线运行，无需网络连接。  
- 适配 R1 模型。  
- 支持多对话管理。  
- 针对 Apple 芯片优化。  

## 与 fullmoon 的不同  

1. 移除了[系统提示词(system prompt)](https://github.com/deepseek-ai/DeepSeek-R1?tab=readme-ov-file#usage-recommendations)（暂时）。  
2. 增加了中文本地化。  
3. 移除了模型下载功能。  
4. 目前仅支持 DeepSeek-R1（暂时）。  

## 如何构建  

### 克隆仓库  

```sh  
git clone https://github.com/OJZen/1chat.git  
```

### 下载模型  

从 [Hugging Face](https://huggingface.co/mlx-community/deepseek-r1-distill-qwen-1.5b) 下载 DeepSeek-R1 模型文件。  

或者，你也可以使用其他模型，但需要满足以下条件：  

1. 必须是 DeepSeek-R1 distill 模型。  
2. 必须是 MLX 格式的模型。  

1.5B 模型在我的 iPhone 15 Pro 上运行的最好，速度足够快。  

### 放置模型  

将所有模型文件放入 [model 文件夹](model)。  

### Xcode，启动！

用 Xcode 打开 1chat 项目，然后构建并运行。  

## 已知问题  

DeepSeek-R1 目前存在一个操蛋的问题，偶尔输出会无止境地重复。  

我不知道怎么解决，所以暂时增加了一个方法，当检测到内容重复时自动截断。
