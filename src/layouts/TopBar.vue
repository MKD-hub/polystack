<script setup lang="ts">
  import {
    Undo2,
    Redo2,
    Layers2,
    Image,
    Shapes,
    Layers,
  } from "lucide-vue-next";
</script>

<template>
  <div
    class="flex items-center justify-between border-b border-slate-200 bg-[#f8fbff] px-6 py-3"
  >
    <div class="flex items-center gap-6">
      <a class="font-bold tracking-[0.02em] text-slate-800">PolyStack</a>
      <nav class="flex gap-4">
        <button
          class="border-b-2 border-blue-700 pb-1 text-sm font-medium text-blue-700"
        >
          3D Viewport
        </button>
        <button
          class="border-b-2 border-transparent pb-1 text-sm font-medium text-slate-500"
        >
          Sprite Editor
        </button>
        <button
          class="border-b-2 border-transparent pb-1 text-sm font-medium text-slate-500"
        >
          Sprite Stack
        </button>
      </nav>
    </div>
    <div class="flex items-center gap-2">
      <span class="tooltip tooltip-bottom" data-tip="undo">
        <button
          class="inline-flex h-9 w-9 items-center justify-center rounded-lg border border-transparent text-slate-500 hover:border-slate-200 hover:bg-[#eff4ff]"
        >
          <Undo2 />
        </button>
      </span>
      <span class="tooltip tooltip-bottom" data-tip="redo">
        <button
          class="inline-flex h-9 w-9 items-center justify-center rounded-lg border border-transparent text-slate-500 hover:border-slate-200 hover:bg-[#eff4ff]"
        >
          <Redo2 />
        </button>
      </span>
      <button
        class="inline-flex h-9 w-9 items-center justify-center rounded-lg border border-transparent text-slate-500 hover:border-slate-200 hover:bg-[#eff4ff]"
      >
        <Layers2 />
      </button>
      <button
        class="inline-flex h-9 w-9 items-center justify-center rounded-lg border border-transparent text-slate-500 hover:border-slate-200 hover:bg-[#eff4ff]"
      >
        <Shapes />
      </button>
      <button
        class="inline-flex h-9 w-9 items-center justify-center rounded-lg border border-transparent text-slate-500 hover:border-slate-200 hover:bg-[#eff4ff]"
      >
        <Image />
      </button>
      <button
        class="btn rounded-full border border-[var(--color-base-300)] bg-[var(--color-base-200)] px-4 text-[var(--color-base-content)] shadow-[0_6px_14px_rgba(31,41,55,0.12),_0_2px_4px_rgba(31,41,55,0.08),_inset_0_1px_0_rgba(255,255,255,0.7)] hover:shadow-[0_8px_18px_rgba(31,41,55,0.14),_0_3px_6px_rgba(31,41,55,0.1),_inset_0_1px_0_rgba(255,255,255,0.75)] active:translate-y-[1px] active:shadow-[0_3px_8px_rgba(31,41,55,0.12),_0_1px_2px_rgba(31,41,55,0.08),_inset_0_1px_0_rgba(255,255,255,0.6)]"
      >
        Render
      </button>
    </div>
  </div>
</template>
