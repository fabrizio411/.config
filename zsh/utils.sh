alias co='g++ -o app'

coe() {
  g++ -o app "$1"
  ./app
}
