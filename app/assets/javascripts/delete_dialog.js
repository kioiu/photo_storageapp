(() => {
  let activeForm = null;

  function ensureDialog() {
    let dialog = document.querySelector('[data-delete-dialog-modal]');
    if (dialog) return dialog;

    dialog = document.createElement('div');
    dialog.className = 'delete-dialog-backdrop';
    dialog.dataset.deleteDialogModal = 'true';
    dialog.hidden = true;
    dialog.innerHTML = `
      <section class="delete-dialog" role="dialog" aria-modal="true" aria-labelledby="delete-dialog-title" aria-describedby="delete-dialog-message">
        <div>
          <p class="eyebrow">Delete photo</p>
          <h2 id="delete-dialog-title">写真を削除しますか？</h2>
          <p id="delete-dialog-message">この操作は取り消せません。</p>
        </div>
        <div class="delete-dialog-actions">
          <button type="button" class="secondary-button" data-delete-dialog-cancel>キャンセル</button>
          <button type="button" class="danger-button" data-delete-dialog-confirm>削除する</button>
        </div>
      </section>
    `;
    document.body.appendChild(dialog);

    dialog.addEventListener('click', (event) => {
      if (event.target === dialog || event.target.closest('[data-delete-dialog-cancel]')) {
        closeDialog(dialog);
      }
    });

    dialog.querySelector('[data-delete-dialog-confirm]').addEventListener('click', () => {
      if (!activeForm) return;

      const form = activeForm;
      activeForm = null;
      form.dataset.deleteDialogConfirmed = 'true';
      closeDialog(dialog);
      form.requestSubmit();
    });

    document.addEventListener('keydown', (event) => {
      if (event.key === 'Escape' && !dialog.hidden) closeDialog(dialog);
    });

    return dialog;
  }

  function openDialog(form) {
    const dialog = ensureDialog();
    activeForm = form;
    dialog.querySelector('#delete-dialog-title').textContent = form.dataset.deleteDialogTitle || '写真を削除しますか？';
    dialog.querySelector('#delete-dialog-message').textContent = form.dataset.deleteDialogMessage || 'この操作は取り消せません。';
    dialog.hidden = false;
    document.body.classList.add('modal-open');
    dialog.querySelector('[data-delete-dialog-cancel]').focus();
  }

  function closeDialog(dialog) {
    dialog.hidden = true;
    activeForm = null;
    document.body.classList.remove('modal-open');
  }

  document.addEventListener('submit', (event) => {
    const form = event.target;
    if (!(form instanceof HTMLFormElement)) return;
    if (!form.dataset.deleteDialog) return;
    if (form.dataset.deleteDialogConfirmed === 'true') return;

    event.preventDefault();
    openDialog(form);
  });
})();
