import { type Ref, ref } from "vue";

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
