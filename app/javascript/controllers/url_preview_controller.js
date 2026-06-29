import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "wrapper", "frame", "unsupported", "link"]

  connect() {
    this.render()
  }

  render() {
    const url = this.inputTarget.value.trim()
    const embedUrl = this.embedUrlFor(url)

    if (!url) {
      this.hidePreview()
      return
    }

    if (!embedUrl) {
      this.showUnsupported(url)
      return
    }

    this.wrapperTarget.hidden = false
    this.frameTarget.src = embedUrl
    this.frameTarget.hidden = false
    this.unsupportedTarget.hidden = true
  }

  hidePreview() {
    this.wrapperTarget.hidden = true
    this.frameTarget.src = ""
    this.frameTarget.hidden = true
    this.unsupportedTarget.hidden = true
    this.linkTarget.href = "#"
    this.linkTarget.textContent = ""
  }

  showUnsupported(url) {
    this.wrapperTarget.hidden = false
    this.frameTarget.src = ""
    this.frameTarget.hidden = true
    this.unsupportedTarget.hidden = false
    this.linkTarget.href = url
    this.linkTarget.textContent = url
  }

  embedUrlFor(url) {
    try {
      const parsed = new URL(url)
      const host = parsed.hostname.replace(/^www\./, "")

      if (host === "youtube.com" || host === "m.youtube.com") {
        const videoId = parsed.searchParams.get("v")
        return videoId ? `https://www.youtube.com/embed/${videoId}` : null
      }

      if (host === "youtu.be") {
        const videoId = parsed.pathname.split("/").filter(Boolean)[0]
        return videoId ? `https://www.youtube.com/embed/${videoId}` : null
      }

      if (host === "vimeo.com") {
        const videoId = parsed.pathname.split("/").filter(Boolean)[0]
        return videoId ? `https://player.vimeo.com/video/${videoId}` : null
      }
    } catch (_error) {
      return null
    }

    return null
  }
}
