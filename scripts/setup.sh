# ================================================
# Utlity to setup necessary folders before build
# ================================================

create_build_dirs() {
  mkdir -p bin build
  echo "Directories 'bin' and 'build' are prepared."
}

cleanup_build_dirs() {
  rm -rf bin build
  echo "Directories 'bin' and 'build' have been deleted."
}

if [[ "$1" == '-d' ]]; then
  cleanup_build_dirs
else
  create_build_dirs
fi