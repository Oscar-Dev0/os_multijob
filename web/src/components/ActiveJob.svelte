<script>
  import { t } from '../lib/locale.svelte.js';
  import { toggleDuty } from '../lib/store.svelte.js';

  let { job, onRemoveRequest } = $props();
</script>

<div class="active-section">
  <div class="section-label">{t('active_label')}</div>
  <div class="active-card">
    <div class="job-info">
      <div>
        <div class="job-title">{job.title}</div>
        <div class="job-desc">{@html job.description}</div>
      </div>
      {#if job.duty}
        <span class="badge badge-duty"><span class="badge-dot"></span> ON DUTY</span>
      {:else}
        <span class="badge badge-active"><span class="badge-dot"></span> ACTIVE</span>
      {/if}
    </div>

    {#if job.jobName !== 'unemployed'}
      <div class="active-actions">
        <button class="btn btn-duty" onclick={toggleDuty}>
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="12" cy="12" r="5"/><line x1="12" y1="1" x2="12" y2="3"/><line x1="12" y1="21" x2="12" y2="23"/><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"/><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"/><line x1="1" y1="12" x2="3" y2="12"/><line x1="21" y1="12" x2="23" y2="12"/><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"/><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"/>
          </svg>
          {job.duty ? t('exit_duty') : t('enter_duty')}
        </button>
        <button class="btn btn-danger" onclick={() => onRemoveRequest(job)}>
          {t('remove_job')}
        </button>
      </div>
    {/if}
  </div>
</div>
