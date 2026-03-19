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
  <div class="navbar bg-white shadow-sm">
    <div class="flex-none">
      <div class="drawer">
        <input id="my-drawer-1" type="checkbox" class="drawer-toggle" />
        <div class="drawer-content">
          <!-- Page content here -->
          <label for="my-drawer-1" class="btn drawer-button">
            <Layers2 class="text-blue-500" />
          </label>
        </div>
        <div class="drawer-side">
          <label
            for="my-drawer-1"
            aria-label="close sidebar"
            class="drawer-overlay"
          ></label>
          <h4 class="tracking-[3px] px-5 py-3 font-bold uppercase">
            Hierarchy
          </h4>
          <ul class="menu bg-base-200 min-h-full w-90 p-4">
            <!-- Sidebar content here -->
            <!-- TODO: dynamically populate with scene graph later -->
            <li><a>Sidebar Item 1</a></li>
            <li><a>Sidebar Item 2</a></li>
          </ul>
          <div class="self-end mb-20">
            <p
              class="text-neutral-600 uppercase font-semibold text-sm px-2 py-2"
            >
              Asset Browser
            </p>
            <div class="flex gap-2 items-center px-2">
              <button class="btn size-25 btn-square shadow-none">
                <Layers class="text-primary-content" />
              </button>
              <button class="btn size-25 btn-square shadow-none">
                <Shapes class="text-primary-content" />
              </button>
              <button class="btn size-25 btn-square shadow-none">
                <Image class="text-primary-content" />
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="flex w-full justify-between">
      <a class="btn text-blue-500 border-none btn-ghost text-xl">PolyStack</a>
      <div class="flex gap-2">
        <button class="btn btn-ghost">
          <Undo2 />
        </button>
        <button class="btn btn-ghost">
          <Redo2 />
        </button>

        <button class="btn bg-primary-content text-base-100">Render</button>
      </div>
    </div>
  </div>
</template>
