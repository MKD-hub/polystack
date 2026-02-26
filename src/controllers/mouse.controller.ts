import { wasmStore } from "@/scripts/wasm-store";

export default class MouseController {
  private isDragging = false;
  private lastX = 0;
  private lastY = 0;
  private canvas: HTMLCanvasElement;

  constructor(canvas: HTMLCanvasElement) {
    this.canvas = canvas;
    this.setupListeners();
  }

  private setupListeners() {
    this.canvas.addEventListener("mousedown", (e) => {
      this.isDragging = true;
      this.lastX = e.clientX;
      this.lastY = e.clientY;
    });

    window.addEventListener("mouseup", () => {
      this.isDragging = false;
    });

    this.canvas.addEventListener("mousemove", (e) => {
      if (!this.isDragging) return;

      const deltaX = e.clientX - this.lastX;
      const deltaY = e.clientY - this.lastY;

      if (wasmStore.exports) {
        wasmStore.exports.cameraRotate(deltaX, deltaY);
      } else {
        return;
      }
      this.lastX = e.clientX;
      this.lastY = e.clientY;
    });

    this.canvas.addEventListener(
      "wheel",
      (e) => {
        e.preventDefault();
        console.log("deltaY", 1 / e.deltaY);
        if (wasmStore.exports) {
          wasmStore.exports.zoom(1 / e.deltaY);
        } else {
          return;
        }
      },
      { passive: false }
    );
  }
}
