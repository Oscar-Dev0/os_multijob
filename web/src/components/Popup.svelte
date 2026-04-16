<script>
  import { t } from '../lib/locale.svelte.js';

  let { show = false, title = '', description = '', onConfirm, onCancel } = $props();
</script>

{#if show}
  <div class="popup active">
    <!-- svelte-ignore a11y_click_events_have_key_events -->
    <!-- svelte-ignore a11y_no_static_element_interactions -->
    <div class="popup-overlay" onclick={onCancel}></div>
    <div class="popup-card">
      <div class="popup-icon">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/>
        </svg>
      </div>
      <h3>{title}</h3>
      <p>{description}</p>
      <div class="popup-btns">
        <button class="btn btn-cancel" onclick={onCancel}>{t('popup_cancel')}</button>
        <button class="btn btn-confirm" onclick={onConfirm}>{t('popup_confirm')}</button>
      </div>
    </div>
  </div>
{/if}
