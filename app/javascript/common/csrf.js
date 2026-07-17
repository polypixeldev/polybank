export default function csrf() {
  return document
    .querySelector('meta[name="csrf-token"]')
    .getAttribute('content')
}