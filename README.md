#  Swift Core ML Diffusers 🧨

This is a native app that shows how to integrate Apple's [Core ML Stable Diffusion implementation](https://github.com/apple/ml-stable-diffusion) in a native Swift UI application. The Core ML port is a simplification of the Stable Diffusion implementation from the [diffusers library](https://github.com/huggingface/diffusers). This application can be used for faster iteration, or as sample code for any use cases.

This is what the app looks like on macOS:
![App Screenshot](screenshot.jpg)

On first launch, the application downloads a zipped archive with a Core ML version of Stability AI's Stable Diffusion v2 base, from [this location in the Hugging Face Hub](https://huggingface.co/pcuenq/coreml-stable-diffusion-2-base/tree/main). This process takes a while, as several GB of data have to be downloaded and unarchived.

For faster inference, we use a very fast scheduler: [DPM-Solver++](https://github.com/LuChengTHU/dpm-solver), that we ported to Swift from our [diffusers DPMSolverMultistepScheduler implementation](https://github.com/huggingface/diffusers/blob/main/src/diffusers/schedulers/scheduling_dpmsolver_multistep.py).

## Compatibility and Performance

- macOS Ventura 13.1, iOS/iPadOS 16.2, Xcode 14.2.
- Performance (after the initial generation, which is slower)
  * ~8s in macOS on MacBook Pro M1 Max (64 GB). Model: Stable Diffusion v2-base, ORIGINAL attention implementation, running on CPU + GPU.
  * 23 ~ 30s on iPhone 13 Pro. Model: Stable Diffusion v2-base, SPLIT_EINSUM attention, CPU + Neural Engine, memory reduction enabled.

See [this post](https://huggingface.co/blog/fast-mac-diffusers) and [this issue](https://github.com/huggingface/swift-coreml-diffusers/issues/31) for additional performance figures.

The application will try to guess the best hardware to run models on. You can override this setting using the `Advanced` section in the cont