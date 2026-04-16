<script>
  import { t } from '../lib/locale.svelte.js';
  import { changeJob } from '../lib/store.svelte.js';

  let { job, index = 0, onRemoveRequest } = $props();
</script>

<div class="job-card" style="animation-delay: {index * 0.05}s">
  <div class="job-info">
    <div>
      <div class="job-title">{job.title}</div>
      <div class="job-desc">{@html job.description}</div>
    </div>
  </div>
  <div class="card-actions">
    <button class="btn btn-select" onclick={() => changeJob(job.jobName)}>
      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
        <polyline points="9 11 12 14 22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/>
      </svg>
      {t('select_job')}
    </button>
    {#if job.jobName !== 'unemployed'}
      <button class="btn btn-danger" onclick={() => onRemoveRequest(job)}>
        {t('remove_job')}
      </button>
    {/if}
  </div>
</div>
