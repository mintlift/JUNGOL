#  Swift Core ML Diffusers 🧨

This is a native app that shows how to integrate Apple's [Core ML Stable Diffusion implementation](https://github.com/apple/ml-stable-diffusion) in a native Swift UI application. The Core ML port is a simplification of the Stable Diffusion implementation from the [diffusers library](https://github.com/huggingface/diffusers). This application can be used for faster iteration, or as sample code for any use cases.

This is what the app looks like on macOS:
![App Screenshot](screenshot.jpg)

On first launch, the application downloads a zipped archive with a Core ML version of Stability AI's Stable Diffusion v2 base, from [this location in the Hugging Face Hub](https://huggingface.co/pcuenq/coreml-stable-diffusion-2-base/tree/main). This process takes a while, as several GB of data have to be downloaded and unarchived.

For faster inference, we use a very fast scheduler: [DPM-Solver++](https://github.com/LuChengTHU/dpm-solver), that we ported to Swift from our [diffusers DPMSolverMultistepScheduler implementation](https://github.com/huggingface/diffusers/blob/main/src/diffusers/schedulers/scheduling_dpmsolver_multistep.py).

## Compatibility and Performance

- macOS Ventura 13.1, iOS/iPadOS 16.2, Xcode 14.2.
- P