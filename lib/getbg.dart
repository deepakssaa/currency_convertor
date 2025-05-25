String getbg(String country) {
  switch (country) {
    case 'USD':
      return 'assets/images/usd.jpeg';
    case 'EUR':
      return 'assets/images/eur.jpeg';
    case 'GBP':
      return 'assets/images/gbp.jpeg';
    case 'AED':
      return 'assets/images/aed.jpeg';
    case 'SAR':
      return 'assets/images/sar.jpeg';
    case 'CAD':
      return 'assets/images/cad.jpeg';
    case 'AUD':
      return 'assets/images/aud.jpeg';
    case 'SGD':
      return 'assets/images/sgd.jpeg';
    case 'JPY':
      return 'assets/images/jpy.jpeg';
    case 'CNY':
      return 'assets/images/cny.jpeg';
    default:
      return 'assets/images/usd.jpeg';
  }
}
