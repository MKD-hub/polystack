<script setup lang="ts">
  import { MousePointer2, Move, Hand, Brush } from "lucide-vue-next";
</script>
<template>
  <div
    aria-label="editor tools"
    class="absolute top-[8%] z-20 left-[45%] bg-base-100 flex items-center gap-3 text-neutral-400 p-2 rounded-lg"
  >
    <button class="btn btn-square">
      <MousePointer2 class="hover:text-primary-content" />
    </button>
    <button class="btn btn-square">
      <Move class="hover:text-primary-content" />
    </button>
    <button class="btn btn-square">
      <Hand class="hover:text-primary-content" />
    </button>
    |
    <button class="btn btn-square">
      <Brush class="hover:text-primary-content" />
    </button>
  </div>
</template>
