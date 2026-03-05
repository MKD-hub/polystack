# PolyStack

*Stack:*
### Vue + WASM + ZIG + WebGL + Typescript


PolyStack is a 3D modeller/sprite stack editor that enables you to make 3D models interactively.

# currently
- Minimal UI
- World Grid


# Roadmap
 - full modeller with grid snapping support
 - sprite editor
 - stack editing


# Compilation instructions:

Before you begin, make sure you have `zig 0.15.2`.
After cloning the repo

 1. Run `bun install`
 2. Navigate to the `zig/` folder
 3. Run `zig build`
 4. Run `bun run dev`


 And that's it!


# Contribution details

 Coming Soon!

## Notes

- If the grid ever renders a large dark wedge, it could mean the quad vertices were supplied in a winding/order that WebGL's rasterizer doesn't like. The fix was to reorder the indices from bottom-left to top-right so the triangles share the preferred winding and clipping artifacts went away.
