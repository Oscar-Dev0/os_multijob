<script>
  import { t } from './lib/locale.svelte.js';
  import { setLocale } from './lib/locale.svelte.js';
  import { fetchNui, isBrowser } from './lib/fetchNui.js';
  import { getJobStore, loadJobs, removeJob } from './lib/store.svelte.js';
  import ActiveJob from './components/ActiveJob.svelte';
  import JobCard from './components/JobCard.svelte';
  import Popup from './components/Popup.svelte';
  import DevToolbar from './components/DevToolbar.svelte';
  import { onMount } from 'svelte';

  const IS_DEV = isBrowser();

  let isOpen = $state(false);
  let currentStyle = $state('side-right');

  // Popup state
  let popupShow = $state(false);
  let popupTitle = $state('');
  let popupDesc = $state('');
  let popupJob = $state(null);

  const store = getJobStore();

  function open(style) {
    if (style) currentStyle = style;
    isOpen = true;
    loadJobs();
  }

  function close() {
    isOpen = false;
    popupShow = false;
    fetchNui('closeStandalone');
  }

  function handleRemoveRequest(job) {
    popupJob = job;
    popupTitle = t('popup_remove_title');
    popupDesc = t('popup_remove_desc', job.title);
    popupShow = true;
  }

  async function confirmRemove() {
    if (popupJob) {
      await removeJob(popupJob.jobName);
    }
    popupShow = false;
    popupJob = null;
  }

  function cancelPopup() {
    popupShow = false;
    popupJob = null;
  }

  function handleKeydown(e) {
    if (e.key === 'Escape') {
      if (popupShow) cancelPopup();
      else close();
    }
  }

  function onStyleChange(style) {
    currentStyle = style;
    if (isOpen) {
      // Re-open with new style
      window.dispatchEvent(new MessageEvent('message', {
        data: { action: 'open', style },
      }));
    }
  }

  onMount(() => {
    const handler = (e) => {
      const d = e.data;
      if (!d || !d.action) return;
      switch (d.action) {
        case 'open':
          open(d.style);
          break;
        case 'close':
          isOpen = false;
          popupShow = false;
          break;
        case 'update-jobs':
          if (isOpen) loadJobs();
          break;
      }
    };
    window.addEventListener('message', handler);

    fetchNui('getLocale').then(data => {
      setLocale(data?.locale || 'es');
    });

    return () => window.removeEventListener('message', handler);
  });

  // Derived
  let activeJob = $derived(store.jobs.find(j => j.disabled));
  let otherJobs = $derived(store.jobs.filter(j => !j.disabled));
</script>

{#if IS_DEV}
  <DevToolbar style={currentStyle} onStyleChange={onStyleChange} />
{/if}

<svelte:window onkeydown={handleKeydown} />

<div id="app" class:active={isOpen} data-style={currentStyle}>
  <!-- svelte-ignore a11y_click_events_have_key_events -->
  <!-- svelte-ignore a11y_no_static_element_interactions -->
  <div id="backdrop" onclick={close}></div>

  <div id="panel">
    <div class="panel-header">
      <div class="header-text">
        <h1>{t('app_title')}</h1>
        <p>{t('app_subtitle')}</p>
      </div>
      <button id="close-btn" onclick={close}>&#10005;</button>
    </div>

    <div class="panel-content">
      {#if activeJob}
        <ActiveJob job={activeJob} onRemoveRequest={handleRemoveRequest} />
      {/if}

      {#if otherJobs.length > 0}
        <div class="section-label">{t('other_label')}</div>
        {#each otherJobs as job, i (job.jobName)}
          <JobCard {job} index={i} onRemoveRequest={handleRemoveRequest} />
        {/each}
      {:else}
        <div class="empty-state">
          <div class="empty-icon">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <rect x="2" y="7" width="20" height="14" rx="2" ry="2"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/>
            </svg>
          </div>
          {t('no_jobs')}
        </div>
      {/if}
    </div>
  </div>
</div>

<Popup
  show={popupShow}
  title={popupTitle}
  description={popupDesc}
  onConfirm={confirmRemove}
  onCancel={cancelPopup}
/>
