com() {
  g++ -o app "$1"

  if [ "$2" = "-e" ]; then
    ./app
  fi
}
