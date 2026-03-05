export interface Prefs {
  canvasWidth: number;
  canvasHeight: number;
  cellSize: number;
  aspect: number;
  gridLineThickness: number;
  sensitivity: number;
  fov: number;
  near: number;
  far: number;
}

const defaultPrefs: Prefs = {
  canvasWidth: document.documentElement.clientWidth,
  canvasHeight: document.documentElement.clientHeight,
  cellSize: 1.0,
  aspect: 16 / 9,
  gridLineThickness: 0.04,
  sensitivity: 0.001,
  fov: 45,
  near: 0.001,
  far: 4000.0,
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
