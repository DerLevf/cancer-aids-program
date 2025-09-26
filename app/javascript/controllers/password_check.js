document.addEventListener("turbo:load", () => {
  attachPasswordChecker();

  // gleich ausführen, falls schon ein Wert drinsteht (z.B. nach Fehlern)
  const pw = document.getElementById("password-input");
  if (pw) pw.dispatchEvent(new Event("input"));
});
