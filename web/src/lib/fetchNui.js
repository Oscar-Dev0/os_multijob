const RES = typeof GetParentResourceName === 'function'
  ? GetParentResourceName()
  : 'os_multijob';

const IS_BROWSER = typeof window !== 'undefined' && !window.invokeNative;

/**
 * @param {string} event
 * @param {any} data
 * @returns {Promise<any>}
 */
export async function fetchNui(event, data = {}) {
  if (IS_BROWSER && window.__mockFetchNui) {
    return window.__mockFetchNui(event, data);
  }
  try {
    const resp = await fetch(`https://${RES}/${event}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json; charset=UTF-8' },
      body: JSON.stringify(data),
    });
    return await resp.json();
  } catch {
    return null;
  }
}

export function isBrowser() {
  return IS_BROWSER;
}
