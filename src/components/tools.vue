<script setup lang="ts">
  import { MousePointer2, Move, Hand, Brush } from "lucide-vue-next";
</script>
<template>
  <div
    aria-label="editor tools"
    class="absolute left-5 top-20 z-10 grid gap-2.5 rounded-xl border border-slate-200 bg-white p-2 shadow-[0_8px_18px_rgba(148,163,184,0.25)]"
  >
    <button
      class="inline-flex h-10 w-10 items-center justify-center rounded-lg bg-blue-50 text-blue-700"
    >
      <MousePointer2 />
    </button>
    <button
      class="inline-flex h-10 w-10 items-center justify-center rounded-lg text-slate-600 hover:bg-blue-50 hover:text-blue-700"
    >
      <Move />
    </button>
    <button
      class="inline-flex h-10 w-10 items-center justify-center rounded-lg text-slate-600 hover:bg-blue-50 hover:text-blue-700"
    >
      <Hand />
    </button>
    <button
      class="inline-flex h-10 w-10 items-center justify-center rounded-lg text-slate-600 hover:bg-blue-50 hover:text-blue-700"
    >
      <Brush />
    </button>
  </div>
</template>
