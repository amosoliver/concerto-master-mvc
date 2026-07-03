import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["audio", "seek", "currentTime", "duration"]

  connect() {
    this.isSeeking = false
    this.audioTarget.addEventListener("loadedmetadata", () => this.updateDuration())
    this.audioTarget.addEventListener("timeupdate", () => this.updateProgress())
    this.audioTarget.addEventListener("play", () => this.onPlay())
    this.audioTarget.addEventListener("pause", () => this.onPause())
    this.audioTarget.addEventListener("ended", () => this.onPause())
  }

  togglePlay() {
    if (this.audioTarget.paused) {
      document.querySelectorAll("audio").forEach((audio) => {
        if (audio !== this.audioTarget) audio.pause()
      })
      this.audioTarget.play()
    } else {
      this.audioTarget.pause()
    }
  }

  skipBack() {
    this.audioTarget.currentTime = Math.max(0, this.audioTarget.currentTime - 10)
  }

  skipForward() {
    const duration = this.audioTarget.duration || 0
    this.audioTarget.currentTime = Math.min(duration, this.audioTarget.currentTime + 10)
  }

  onSeekInput() {
    this.isSeeking = true
    const duration = this.audioTarget.duration || 0
    this.currentTimeTarget.textContent = this.formatTime((this.seekTarget.value / 100) * duration)
  }

  onSeekChange() {
    const duration = this.audioTarget.duration || 0
    this.audioTarget.currentTime = (this.seekTarget.value / 100) * duration
    this.isSeeking = false
  }

  updateDuration() {
    this.durationTarget.textContent = this.formatTime(this.audioTarget.duration)
  }

  updateProgress() {
    if (this.isSeeking) return

    const duration = this.audioTarget.duration || 0
    const percent = duration ? (this.audioTarget.currentTime / duration) * 100 : 0
    this.seekTarget.value = percent
    this.currentTimeTarget.textContent = this.formatTime(this.audioTarget.currentTime)
  }

  onPlay() {
    this.element.classList.add("is-playing")
  }

  onPause() {
    this.element.classList.remove("is-playing")
  }

  formatTime(seconds) {
    if (!isFinite(seconds) || isNaN(seconds)) return "0:00"

    const mins = Math.floor(seconds / 60)
    const secs = Math.floor(seconds % 60).toString().padStart(2, "0")
    return `${mins}:${secs}`
  }
}
