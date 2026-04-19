import { wasmStore } from "@/scripts/wasm-store";
import useContextMenu from "@/composables/useContextMenu";

export default class MouseController {
  private isDragging = false;
  private lastX = 0;
  private lastY = 0;
  private canvas: HTMLCanvasElement;
  private cm: ReturnType<typeof useContextMenu>;

  constructor(canvas: HTMLCanvasElement) {
    this.canvas = canvas;
    this.setupListeners();
    this.cm = useContextMenu();
  }

  public handleContextMenuClick(e: MouseEvent) {
    e.preventDefault();
    this.cm.openAt(e);
  }

  public getContextMenu() {
    return {
      open: this.cm.open,
      x: this.cm.x,
      y: this.cm.y,
      openAt: this.cm.openAt,
      close: this.cm.close,
    };
  }

  private setupListeners() {
    this.canvas.addEventListener("mousedown", (e) => {
      this.isDragging = true;
      this.lastX = e.clientX;
      this.lastY = e.clientY;
      // close context menu
      this.cm.close();
    });

    window.addEventListener("mouseup", () => {
      this.isDragging = false;
    });

    this.canvas.addEventListener("contextmenu", (e: MouseEvent) => {
      e.preventDefault();
      this.handleContextMenuClick(e);
    });

    this.canvas.addEventListener("mousemove", (e) => {
      if (!this.isDragging) return;

      const deltaX = e.clientX - this.lastX;
      const deltaY = e.clientY - this.lastY;

      if (wasmStore.exports) {
        if (e.shiftKey) {
          wasmStore.exports.pan(-deltaX, deltaY);
          return;
        }
      } else {
        return;
      }

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
