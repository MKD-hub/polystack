import { type Ref, ref } from "vue";

const boundContextMenu = (
  canvasRef: Ref<HTMLCanvasElement | undefined>,
  x: number,
  y: number
): { x: number; y: number } | undefined => {
  if (!canvasRef.value) {
    return;
  }
  const bounds = canvasRef.value.getBoundingClientRect();
  if (!bounds) {
    return { x, y };
  }

  if (x + 300 >= bounds.right) {
    x = bounds.right - 300;
  }
  if (x <= bounds.left) {
    x = bounds.left;
  }
  if (y <= bounds.top) {
    y = bounds.top;
  }
  if (y + 300 >= bounds.bottom) {
    y = bounds.bottom - 300;
  }

  return { x, y };
};

/**
 * @param canvasRef {HTMLCanvasElement}
 * @param getCanvasPos a function for getting the canvas position
 */
const useContextMenu = (canvasRef: Ref<HTMLCanvasElement | undefined>) => {
  const open = ref(false);
  const x = ref(0);
  const y = ref(0);

  const openAt = (e: MouseEvent) => {
    e.preventDefault();
    open.value = true;
    x.value = e.clientX;
    y.value = e.clientY;
    //TODO: use pos.x and pos.y to render context menu under the mouse appropriately
    //TODO: perform checks to bound the context menu to canvas borders
  };

  const close = () => {
    open.value = false;
  };

  return { open, x, y, openAt, close };
};

export default useContextMenu;
