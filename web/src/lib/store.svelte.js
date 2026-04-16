import { fetchNui } from './fetchNui.js';

/**
 * @typedef {Object} Job
 * @property {string} title
 * @property {string} description
 * @property {boolean} disabled
 * @property {string} jobName
 * @property {boolean} duty
 */

/** @type {{ jobs: Job[], loading: boolean }} */
let state = $state({ jobs: [], loading: false });

export function getJobStore() {
  return state;
}

export async function loadJobs() {
  state.loading = true;
  try {
    const res = await fetchNui('getJobs');
    const list = Array.isArray(res) ? res : (res?.jobs || []);
    list.sort((a, b) => (a.title || '').localeCompare(b.title || ''));
    state.jobs = list;
  } catch {
    state.jobs = [];
  }
  state.loading = false;
}

export async function toggleDuty() {
  await fetchNui('toggleDuty');
  await new Promise(r => setTimeout(r, 400));
  await loadJobs();
}

export async function changeJob(jobName) {
  await fetchNui('changeJob', jobName);
  await new Promise(r => setTimeout(r, 300));
  await loadJobs();
}

export async function removeJob(jobName) {
  await fetchNui('removeJob', jobName);
  await new Promise(r => setTimeout(r, 300));
  await loadJobs();
}
