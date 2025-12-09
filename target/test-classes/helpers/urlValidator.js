function isValidURL(str) {
  try {
    const url = new URL(str);
    // Sadece png ve jpg uzantılarını kontrol et
    if (url.protocol === 'https:') {
      return true;
    } else {
      throw new Error('Invalid file extension');
    }
  } catch (_) {
    return false;
  }
}