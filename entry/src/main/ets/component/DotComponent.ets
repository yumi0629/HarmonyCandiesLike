import { degToRad, clamp, mapValueFromRangeToRange, lerpColorsWithAlpha } from '../utils/LikeButtonUtils'

@Component
export struct DotComponent {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  @Prop @Watch('onProgressUpdate') currentProgress: number
  private dotCount = 7
  private outerDotsPositionAngle = 360.0 / this.dotCount
  private color1 = "#FFFFC107"
  private color2 = "#FFFF9800"
  private color3 = "#FFFF5722"
  private color4 = "#FFF44336"
  private colors = [this.color1, this.color2, this.color3, this.color4]
  private centerX = 0
  private centerY = 0
  private maxDotSize = 0
  private maxOuterDotsRadius = 0
  private maxInnerDotsRadius = 0
  private currentRadius1 = 0.0;
  private currentDotSize1 = 0.0;
  private currentDotSize2 = 0.0;
  private currentRadius2 = 0.0;

  build() {
    Canvas(this.context)
      .width('100%')
      .height('100%')
      .onReady(() => {
        this.centerX = this.context.width * 0.5
        this.centerY = this.context.height * 0.5
        this.maxDotSize = Math.min(this.context.width, this.context.height) * 0.05
        this.maxOuterDotsRadius = Math.min(this.context.width, this.context.height) * 0.5 - this.maxDotSize * 2
        this.maxInnerDotsRadius = 0.8 * this.maxOuterDotsRadius
      })
  }

  onProgressUpdate() {
    this.context.clearRect(0, 0, this.context.width, this.context.height)
    this._draw()
  }

  _draw() {
    this._updateOuterDotsPosition();
    this._updateInnerDotsPosition();
    this._updateDotsColors();
    this._drawOuterDotsFrame();
    this._drawInnerDotsFrame();
  }

  _updateOuterDotsPosition() {
    if (this.currentProgress < 0.3) {
      this.currentRadius1 = mapValueFromRangeToRange(
        this.currentProgress, 0.0, 0.3, 0.0, this.maxOuterDotsRadius * 0.8);
    } else {
      this.currentRadius1 = mapValueFromRangeToRange(this.currentProgress, 0.3, 1.0, 0.8 * this.maxOuterDotsRadius, this.maxOuterDotsRadius);
    }
    if (this.currentProgress == 0) {
      this.currentDotSize1 = 0;
    } else if (this.currentProgress < 0.7) {
      this.currentDotSize1 = this.maxDotSize;
    } else {
      this.currentDotSize1 = mapValueFromRangeToRange(this.currentProgress, 0.7, 1.0, this.maxDotSize, 0.0);
    }
  }

  _updateInnerDotsPosition() {
    if (this.currentProgress < 0.3) {
      this.currentRadius2 = mapValueFromRangeToRange(this.currentProgress, 0.0, 0.3, 0.0, this.maxInnerDotsRadius);
    } else {
      this.currentRadius2 = this.maxInnerDotsRadius;
    }
    if (this.currentProgress == 0) {
      this.currentDotSize2 = 0;
    } else if (this.currentProgress < 0.2) {
      this.currentDotSize2 = this.maxDotSize;
    } else if (this.currentProgress < 0.5) {
      this.currentDotSize2 = mapValueFromRangeToRange(this.currentProgress, 0.2, 0.5, this.maxDotSize, 0.3 * this.maxDotSize);
    } else {
      this.currentDotSize2 = mapValueFromRangeToRange(this.currentProgress, 0.5, 1.0, this.maxDotSize * 0.3, 0.0);
    }
  }

  _updateDotsColors() {
    var progress = clamp(this.currentProgress, 0.6, 1.0);
    var alpha = Math.round(mapValueFromRangeToRange(progress, 0.6, 1.0, 255.0, 0.0))
    if (this.currentProgress < 0.5) {
      progress = mapValueFromRangeToRange(this.currentProgress, 0.0, 0.5, 0.0, 1.0);
    } else {
      progress = mapValueFromRangeToRange(this.currentProgress, 0.5, 1.0, 0.0, 1.0);
    }
    this.colors[0] = lerpColorsWithAlpha(this.color1, this.color2, progress, alpha);
    this.colors[1] = lerpColorsWithAlpha(this.color2, this.color3, progress, alpha);
    this.colors[2] = lerpColorsWithAlpha(this.color3, this.color4, progress, alpha);
    this.colors[3] = lerpColorsWithAlpha(this.color4, this.color1, progress, alpha);
  }

  _drawOuterDotsFrame() {
    for (let i = 0; i < this.dotCount; i++) {
      var cX = this.centerX + this.currentRadius1 * Math.cos(i * degToRad(this.outerDotsPositionAngle));
      var cY = this.centerY + this.currentRadius1 * Math.sin(i * degToRad(this.outerDotsPositionAngle));
      this.context.fillStyle = this.colors[(i + 1) % this.colors.length]
      this.context.beginPath()
      this.context.arc(cX, cY, this.currentDotSize1, 0, Math.PI * 2);
      this.context.fill()
    }
  }

  _drawInnerDotsFrame() {
    for (let i = 0; i < this.dotCount; i++) {
      var cX = this.centerX + this.currentRadius2 * Math.cos(i * degToRad(this.outerDotsPositionAngle - 10));
      var cY = this.centerY + this.currentRadius2 * Math.sin(i * degToRad(this.outerDotsPositionAngle - 10));
      this.context.fillStyle = this.colors[(i + 1) % this.colors.length]
      this.context.beginPath()
      this.context.arc(cX, cY, this.currentDotSize2, 0, Math.PI * 2);
      this.context.fill()
    }
  }
}