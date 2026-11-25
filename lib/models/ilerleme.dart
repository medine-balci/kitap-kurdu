double ilerlemeOrani(int kaldigiSayfa, int sayfaSayisi) {
  if (sayfaSayisi <= 0 || kaldigiSayfa <= 0) return 0;
  if (kaldigiSayfa >= sayfaSayisi) return 1;
  return kaldigiSayfa / sayfaSayisi;
}
int ilerlemeYuzdesi(int kaldigiSayfa, int sayfaSayisi) {
  return (ilerlemeOrani(kaldigiSayfa, sayfaSayisi) * 100).round();
}