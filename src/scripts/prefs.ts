export interface Prefs {
  canvasWidth: number;
  canvasHeight: number;
  aspect: number;
  gridSize: number;
  gridLineThickness: number;
  gridSpacingMajor: number;
  gridSpacingMinor: number;
  sensitivity: number;
  fov: number;
  near: number;
  far: number;
  gridColor: { r: number; g: number; b: number; a: number };
}

const defaultPrefs: Prefs = {
  canvasWidth: document.documentElement.clientWidth,
  canvasHeight: document.documentElement.clientHeight,
  aspect: 16 / 9,
  gridSize: 2000,
  gridLineThickness: 0.04,
  gridSpacingMajor: 4.0,
  gridSpacingMinor: 1.0,
  sensitivity: 0.001,
  fov: 45,
  near: 0.001,
  far: 4000.0,
  gridColor: { r: 0.624, g: 0.651, b: 0.678, a: 1 },
};

export function loadPrefs(): Prefs {
  const stored = localStorage.getItem("modellerPrefs");
  if (stored) {
    try {
      return JSON.parse(stored) as Prefs;
    } catch {
      return defaultPrefs;
    }
  }
  return defaultPrefs;
}

export function savePrefs(prefs: Prefs) {
  localStorage.setItem("modellerPrefs", JSON.stringify(prefs));
}
