<script>
  let { style = 'side-right', onStyleChange } = $props();

  const styles = ['side-right', 'side-left', 'fullscreen', 'compact', 'centered', 'floating', 'bottom'];
</script>

<!-- svelte-ignore a11y_click_events_have_key_events -->
<!-- svelte-ignore a11y_no_static_element_interactions -->
<div class="dev-toolbar">
  <div class="dev-group">
    <span class="dev-label">Layout</span>
    {#each styles as s}
      <button
        class="dev-btn"
        class:active={style === s}
        onclick={() => onStyleChange(s)}
      >{s}</button>
    {/each}
  </div>
</div>

<style>
  .dev-toolbar {
    position: fixed;
    top: 0;
    left: 50%;
    transform: translateX(-50%);
    z-index: 99999;
    display: flex;
    gap: 1rem;
    align-items: center;
    padding: 8px 16px;
    background: rgba(10, 16, 30, 0.92);
    border: 1px solid rgba(45, 140, 240, 0.2);
    border-top: none;
    border-radius: 0 0 12px 12px;
    backdrop-filter: blur(12px);
    font-family: 'Inter', system-ui, sans-serif;
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.5);
  }
  .dev-group {
    display: flex;
    align-items: center;
    gap: 6px;
  }
  .dev-label {
    font-size: 11px;
    text-transform: uppercase;
    letter-spacing: 0.1em;
    color: #6b82a6;
    font-weight: 600;
    margin-right: 2px;
  }
  .dev-btn {
    padding: 5px 12px;
    border: 1px solid rgba(255, 255, 255, 0.08);
    border-radius: 6px;
    background: rgba(255, 255, 255, 0.04);
    color: #94a8c8;
    font-size: 12px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.15s ease;
  }
  .dev-btn:hover {
    background: rgba(45, 140, 240, 0.12);
    border-color: rgba(45, 140, 240, 0.3);
    color: #e8f0ff;
  }
  .dev-btn.active {
    background: linear-gradient(135deg, #2d8cf0, #0f5fc2);
    border-color: transparent;
    color: #fff;
    box-shadow: 0 4px 14px rgba(45, 140, 240, 0.35);
  }
</style>
