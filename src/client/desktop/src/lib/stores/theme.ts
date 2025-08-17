import { writable } from 'svelte/store';
import { browser } from '$app/environment';

// 主题类型
export type Theme = 'light' | 'dark';

// 从localStorage获取初始主题，默认为light
function createThemeStore() {
  const defaultTheme: Theme = 'light';
  
  // 在浏览器环境中从localStorage读取主题
  const storedTheme = browser ? localStorage.getItem('theme') as Theme : null;
  const initialTheme = storedTheme || defaultTheme;
  
  const { subscribe, set, update } = writable<Theme>(initialTheme);
  
  return {
    subscribe,
    set: (theme: Theme) => {
      if (browser) {
        localStorage.setItem('theme', theme);
        // 更新HTML根元素的class
        document.documentElement.classList.toggle('dark', theme === 'dark');
      }
      set(theme);
    },
    toggle: () => {
      update(currentTheme => {
        const newTheme = currentTheme === 'light' ? 'dark' : 'light';
        if (browser) {
          localStorage.setItem('theme', newTheme);
          document.documentElement.classList.toggle('dark', newTheme === 'dark');
        }
        return newTheme;
      });
    }
  };
}

export const theme = createThemeStore();
