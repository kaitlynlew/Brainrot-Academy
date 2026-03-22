// ============================================================
//  BRAINROT ACADEMY — Main Client JS
// ============================================================

// ── Mobile Nav ───────────────────────────────────────────────
const hamburger = document.getElementById("hamburger");
const mobileMenu = document.getElementById("mobileMenu");

if (hamburger && mobileMenu) {
  hamburger.addEventListener("click", () => {
    mobileMenu.classList.toggle("open");
    hamburger.textContent = mobileMenu.classList.contains("open") ? "✕" : "☰";
  });

  // Close on outside click
  document.addEventListener("click", (e) => {
    if (!hamburger.contains(e.target) && !mobileMenu.contains(e.target)) {
      mobileMenu.classList.remove("open");
      hamburger.textContent = "☰";
    }
  });
}

// ── Toast Notification ───────────────────────────────────────
function showToast(msg, duration = 3000) {
  const existing = document.querySelector(".toast");
  if (existing) existing.remove();

  const toast = document.createElement("div");
  toast.className = "toast";
  toast.textContent = msg;
  document.body.appendChild(toast);

  setTimeout(() => {
    toast.style.opacity = "0";
    toast.style.transform = "translateY(20px)";
    toast.style.transition = "all 0.3s";
    setTimeout(() => toast.remove(), 300);
  }, duration);
}

// ── Filter form: auto-submit selects (Learn page) ────────────
document.querySelectorAll(".filter-bar select").forEach((select) => {
  select.addEventListener("change", () => {
    select.closest("form").submit();
  });
});

// ── Note form: live preview of color ─────────────────────────
const colorRadios = document.querySelectorAll('input[name="color"]');
const noteFormCard = document.querySelector(".note-form-card");

if (colorRadios.length && noteFormCard) {
  colorRadios.forEach((radio) => {
    radio.addEventListener("change", () => {
      const val = radio.value;
      // Remove all note color classes
      noteFormCard.className = noteFormCard.className
        .replace(/note-\w+/g, "")
        .trim();
      noteFormCard.classList.add(`note-${val}`);
    });
  });

  // Apply on load
  const checked = document.querySelector('input[name="color"]:checked');
  if (checked) {
    noteFormCard.classList.add(`note-${checked.value}`);
  }
}

// ── Register: password strength indicator ────────────────────
const pwInput = document.getElementById("password");
const cpInput = document.getElementById("confirm_password");

if (pwInput && cpInput) {
  cpInput.addEventListener("input", () => {
    if (cpInput.value && cpInput.value !== pwInput.value) {
      cpInput.style.borderColor = "var(--red)";
    } else {
      cpInput.style.borderColor = "";
    }
  });
}

// ── Keyboard shortcut: / to focus search ─────────────────────
document.addEventListener("keydown", (e) => {
  if (
    e.key === "/" &&
    document.activeElement.tagName !== "INPUT" &&
    document.activeElement.tagName !== "TEXTAREA"
  ) {
    const searchInput = document.querySelector(".filter-search input");
    if (searchInput) {
      e.preventDefault();
      searchInput.focus();
    }
  }
});

// ── Confirm delete on notes ───────────────────────────────────
// (handled inline with onsubmit in the EJS, but also here for safety)
document.querySelectorAll("form[data-confirm]").forEach((form) => {
  form.addEventListener("submit", (e) => {
    if (!confirm(form.dataset.confirm)) {
      e.preventDefault();
    }
  });
});

// ── Animate stat numbers (dashboard) ─────────────────────────
function animateCount(el, target, duration = 800) {
  const start = performance.now();
  const update = (time) => {
    const elapsed = time - start;
    const progress = Math.min(elapsed / duration, 1);
    const eased = 1 - Math.pow(1 - progress, 3);
    el.textContent = Math.round(eased * target);
    if (progress < 1) requestAnimationFrame(update);
  };
  requestAnimationFrame(update);
}

document.querySelectorAll(".stat-num[data-count]").forEach((el) => {
  const target = parseInt(el.dataset.count);
  if (!isNaN(target)) animateCount(el, target);
});

console.log("🧠 Brainrot Academy loaded. No cap.");
