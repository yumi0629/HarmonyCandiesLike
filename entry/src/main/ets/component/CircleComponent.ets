import { clamp, mapValueFromRangeToRange, lerpColors } from '../utils/LikeButtonUtils'

@Preview
@Component
export struct CircleComponent {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  @Prop @Watch('onProgressUpdate') innerCircleRadiusProgress: number
  @Prop @Watch('onProgressUpdate') outerCircleRadiusProgress: number
  private startColor: string = '#FFFF5722'
  private endColor: string = '#FFFFC107'
  private color: string
  private centerX = 0
  private centerY = 0
  private radius = 0

  build() {
    Canvas(this.context)
      .width('100%')
      .height('100%')
      .onReady(() => {
        this.centerX = this.context.width * 0.5
        this.centerY = this.context.height * 0.5
        this.radius = Math.min(this.centerX, this.centerY)
      })
  }

  onProgressUpdate() {
    this.context.clearRect(0, 0, this.context.width, this.context.height)
    this._draw()
  }

  _draw() {
    this._updateCircleColor()
    this.context.fillStyle = this.color
    this.context.beginPath()
    this.context.arc(this.centerX, this.centerY, this.radius * this.outerCircleRadiusProgress, 0, Math.PI * 2)
    this.context.fill()

    if (this.innerCircleRadiusProgress > 0) {
      this.context.save()
      this.context.beginPath()
      this.context.arc(this.centerX, this.centerY, this.radius * this.innerCircleRadiusProgress, 0, Math.PI * 2)
      this.context.clip()
      this.context.clearRect(0, 0, this.context.width, this.context.height)
      this.context.restore()
      console.log("1111111111", `clearRect`)
    }

    console.log("1111111111", `outRadius = ${this.radius * this.outerCircleRadiusProgress}, innerRadius = ${this.radius * this.innerCircleRadiusProgress}`)

    console.log("1111111111", `outerCircleRadiusProgress = ${this.outerCircleRadiusProgress}, innerCircleRadiusProgress = ${this.innerCircleRadiusProgress}`)
  }

  _updateCircleColor() {
    var colorProgress = clamp(this.outerCircleRadiusProgress, 0.5, 1.0)
    colorProgress = mapValueFromRangeToRange(colorProgress, 0.5, 1.0, 0.0, 1.0)
    this.color = lerpColors(this.startColor, this.endColor, colorProgress)
  }
}