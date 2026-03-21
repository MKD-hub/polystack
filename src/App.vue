<script setup lang="ts">
  const VEC3_WIDTH = 3; // 3 elements per Vec3

  import { onMounted, onUnmounted, ref } from "vue";
  import { initCanvas, clear } from "@/scripts/webgl";
  import { loadPrefs } from "@/scripts/prefs";
  import { initShaderProgram, setupUniforms } from "@/gl";
  import TopBar from "@/layouts/TopBar.vue";
  import Footer from "@/layouts/Footer.vue";
  import Tools from "@/components/tools.vue";
  import { wasmStore } from "@/scripts/wasm-store";
  import { loadWasm } from "@/scripts/loader";
  import { Reader } from "@/utils/utils";
  import { drawGridQuad } from "@/core/draw-grid-quad";
  import MouseController from "@/controllers/mouse.controller.ts";
  import { useContextMenu } from "@/composables/useContextMenu.ts";

  import vsSource from "@/gl/grid.vertex.glsl?raw";
  import fsSource from "@/gl/grid.frag.glsl?raw";

  let g_view_mat: number;
  let g_perspective_mat: number;

  const canvas = ref<HTMLCanvasElement | null>(null);
  let animationId: number;

  // @ts-expect-error: prefs is used in the template code below
  const prefs = loadPrefs();

  onMounted(async () => {
    void (await loadWasm());
    const mc = new MouseController(canvas.value!);
    const cm = useContextMenu();

    // Load editor config
    void wasmStore.exports.getEditorConfig(
      prefs.fov,
      prefs.aspect,
      prefs.near,
      prefs.far,
      prefs.sensitivity,
      prefs.canvasWidth,
      prefs.canvasHeight
    );

    const v_grid = wasmStore.exports.getGridVerts();
    const t_grid = wasmStore.exports.getGridTriangles();

    const v_grid_view = Reader(
      v_grid,
      VEC3_WIDTH * 4,
      Float32Array,
      wasmStore.exports
    );
    const t_grid_view = Reader(
      t_grid,
      VEC3_WIDTH * 2,
      Uint16Array,
      wasmStore.exports
    );

    const gl = initCanvas(canvas.value);
    const shaderProgram = initShaderProgram(gl, vsSource, fsSource);
    gl.useProgram(shaderProgram);
    const grid_buffer = gl.createBuffer();

    void setupUniforms(gl, shaderProgram, prefs);

    const render = () => {
      void clear(gl);
      void wasmStore.exports.updateCamera();
      g_view_mat = wasmStore.exports.returnViewMatrix();
      g_perspective_mat = wasmStore.exports.returnPerspectiveMatrix();

      const grid_quad_ptr = wasmStore.exports.generateAndReturnGridQuad(
        prefs.gridSize
      );
      const grid_model_mat = Reader(
        grid_quad_ptr,
        16,
        Float32Array,
        wasmStore.exports
      );

      const cam_pos = wasmStore.exports.getCameraPos();
      const cam_pos_view = Reader(
        cam_pos,
        VEC3_WIDTH,
        Float32Array,
        wasmStore.exports
      );

      const view_mat = Reader(g_view_mat, 16, Float32Array, wasmStore.exports);
      const proj_mat = Reader(
        g_perspective_mat,
        16,
        Float32Array,
        wasmStore.exports
      );

      gl.disable(gl.CULL_FACE);
      drawGridQuad(
        gl,
        shaderProgram,
        cam_pos_view,
        v_grid_view,
        t_grid_view,
        grid_model_mat,
        view_mat,
        proj_mat
      );
      animationId = requestAnimationFrame(render);
    };

    render();
  });

  onUnmounted(async () => {
    // clean-up
    cancelAnimationFrame(animationId);
  });
</script>

<template>
  <div class="min-h-screen bg-[#f6f9fc] text-[color:var(--color-base-content)]">
    <TopBar />

    <div
      class="grid min-h-[calc(100vh-120px)] grid-cols-[260px_minmax(0,1fr)_300px]"
    >
      <aside class="border-r border-slate-200 bg-[#f3f6fb] p-4">
        <div class="mb-4 flex items-center justify-between">
          <div>
            <p class="text-[0.75rem] font-semibold uppercase tracking-[0.12em] text-slate-500">
              Project
            </p>
            <p class="text-sm font-semibold text-slate-800">Hierarchy</p>
          </div>
          <span class="text-xs text-slate-400">v1.0.4</span>
        </div>
        <ul class="grid gap-1">
          <li class="rounded-lg px-2.5 py-1.5 text-sm text-slate-600">
            Main_Camera
          </li>
          <li class="rounded-lg px-2.5 py-1.5 text-sm text-slate-600">
            Directional_Light
          </li>
          <li
            class="rounded-lg bg-blue-100 px-2.5 py-1.5 text-sm font-semibold text-blue-700"
          >
            Cube_Mesh_01
          </li>
          <li class="rounded-lg px-2.5 py-1.5 text-sm text-slate-600">
            Ground_Plane
          </li>
        </ul>
      </aside>

      <main class="relative overflow-hidden border-x border-slate-200 bg-[#f8fbff]">
        <Tools />
        <div class="relative h-full w-full">
          <canvas
            ref="canvas"
            class="absolute inset-0"
            title="3D Renderer"
            :width="prefs.canvasWidth"
            :height="prefs.canvasHeight"
          />
        </div>
      </main>

      <aside class="border-l border-slate-200 bg-white p-4">
        <div class="mb-4 flex items-center gap-4">
          <button class="border-b-2 border-blue-700 pb-1 text-sm font-medium text-blue-700">
            Properties
          </button>
          <button class="border-b-2 border-transparent pb-1 text-sm font-medium text-slate-500">
            Materials
          </button>
          <span class="ml-auto text-xs text-slate-400">Cube_01</span>
        </div>
        <div class="mb-4 rounded-xl border border-slate-200 bg-[#eef2f7] p-4">
          <p class="text-[0.75rem] font-semibold uppercase tracking-[0.12em] text-slate-500">
            Transform
          </p>
          <div class="mt-3">
            <span class="text-[0.7rem] font-semibold uppercase tracking-[0.1em] text-slate-500">
              Position
            </span>
            <div class="mt-2 grid grid-cols-3 gap-2">
              <div class="rounded-lg border border-slate-200 bg-white px-2 py-1.5 text-xs text-slate-800">
                X 0.00
              </div>
              <div class="rounded-lg border border-slate-200 bg-white px-2 py-1.5 text-xs text-slate-800">
                Y 1.25
              </div>
              <div class="rounded-lg border border-slate-200 bg-white px-2 py-1.5 text-xs text-slate-800">
                Z 0.00
              </div>
            </div>
          </div>
          <div class="mt-3">
            <span class="text-[0.7rem] font-semibold uppercase tracking-[0.1em] text-slate-500">
              Rotation Y
            </span>
            <div
              class="relative mt-2 h-1 rounded-full bg-blue-100 after:absolute after:left-[20%] after:-top-1 after:h-3.5 after:w-3.5 after:rounded-full after:bg-blue-700 after:content-['']"
            ></div>
          </div>
          <div class="mt-3">
            <span class="text-[0.7rem] font-semibold uppercase tracking-[0.1em] text-slate-500">
              Scale Uniform
            </span>
            <div
              class="relative mt-2 h-1 rounded-full bg-blue-100 after:absolute after:left-[20%] after:-top-1 after:h-3.5 after:w-3.5 after:rounded-full after:bg-blue-700 after:content-['']"
            ></div>
          </div>
        </div>
        <div class="mb-4 rounded-xl border border-slate-200 bg-[#eef2f7] p-4">
          <p class="text-[0.75rem] font-semibold uppercase tracking-[0.12em] text-slate-500">
            Material
          </p>
          <div class="mb-3 mt-2 flex items-center gap-2.5 rounded-lg border border-slate-200 bg-white p-2.5">
            <div class="h-8 w-8 rounded-md bg-blue-600"></div>
            <div>
              <p class="text-sm font-semibold text-slate-800">
                Standard_Shader
              </p>
              <p class="text-[0.7rem] tracking-[0.05em] text-slate-400">
                PBR WORKFLOW
              </p>
            </div>
          </div>
          <button
            class="btn btn-sm rounded-full border border-[var(--color-base-300)] bg-[var(--color-base-200)] px-4 text-[var(--color-base-content)] shadow-[0_6px_14px_rgba(31,41,55,0.12),_0_2px_4px_rgba(31,41,55,0.08),_inset_0_1px_0_rgba(255,255,255,0.7)] hover:shadow-[0_8px_18px_rgba(31,41,55,0.14),_0_3px_6px_rgba(31,41,55,0.1),_inset_0_1px_0_rgba(255,255,255,0.75)] active:translate-y-[1px] active:shadow-[0_3px_8px_rgba(31,41,55,0.12),_0_1px_2px_rgba(31,41,55,0.08),_inset_0_1px_0_rgba(255,255,255,0.6)]"
          >
            Edit Shader Graph
          </button>
        </div>
      </aside>
    </div>

    <Footer />
  </div>
</template>
