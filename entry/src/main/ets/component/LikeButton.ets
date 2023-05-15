import { CircleComponent } from '../component/CircleComponent'
import { DotComponent } from '../component/DotComponent'
import Animator from '@ohos.animator'
import Curves from '@ohos.curves'

@Component
export struct LikeButton {
  @State isLike: boolean = false
  @State outerCircleProgress: number = 0
  @State innerCircleProgress: number = 0
  @State dotProgress: number = 0
  @State iconScale: number = 1
  private dotAnimator: any = undefined
  private iconAnimator: any = undefined
  private outerCircleAnimator: any = undefined
  private innerCircleAnimator: any = undefined

  aboutToAppear() {
    let _this = this
    this.iconAnimator = Animator.create({
      duration: 350,
      easing: 'linear',
      delay: 350,
      fill: "forwards",
      direction: "normal",
      iterations: 1,
      begin: 0.1,
      end: 1
    });
    this.iconAnimator.onframe = function (value) {
      _this.iconScale = _this._interpolate(value)
    }

    this.dotAnimator = Animator.create({
      duration: 900,
      easing: "friction",
      delay: 100,
      fill: "forwards",
      direction: "normal",
      iterations: 1,
      begin: 0.0,
      end: 1.0
    });
    this.dotAnimator.onframe = function (value) {
      _this.dotProgress = value
    }

    this.outerCircleAnimator = Animator.create({
      duration: 300,
      easing: "ease",
      delay: 0,
      fill: "forwards",
      direction: "normal",
      iterations: 1,
      begin: 0.1,
      end: 1.0
    });
    this.outerCircleAnimator.onframe = function (value) {
      _this.outerCircleProgress = value
    }

    this.innerCircleAnimator = Animator.create({
      duration: 300,
      easing: "ease",
      delay: 200,
      fill: "forwards",
      direction: "normal",
      iterations: 1,
      begin: 0.2,
      end: 1.0
    });
    this.innerCircleAnimator.onframe = function (value) {
      _this.innerCircleProgress = value
    }
  }

  build() {
    Stack() {
      CircleComponent({
        innerCircleRadiusProgress: this.innerCircleProgress,
        outerCircleRadiusProgress: this.outerCircleProgress
      })
        .width('50%')
        .height('50%')
      DotComponent({ currentProgress: this.dotProgress })
        .width('100%')
        .height('100%')
      if (this.isLike) {
        Image($r('app.media.like'))
          .width('35%')
          .height('35%')
          .scale({ x: this.iconScale, y: this.iconScale })
          .objectFit(ImageFit.Contain)
      } else {
        Image($r('app.media.unlike'))
          .width('35%')
          .height('35%')
          .objectFit(ImageFit.Contain)
      }

    }
    .width('100%')
    .height('100%')
    .onClick(() => {
      this.isLike = !this.isLike
      if (this.isLike) {
        this.dotAnimator.play()
        this.outerCircleAnimator.play()
        this.innerCircleAnimator.play()
        this.iconAnimator.play()
      }
    })
  }

  _interpolate(fraction: number): number {
    let period = 2.5
    fraction -= 1.0;
    return fraction * fraction * ((period + 1) * fraction + period) + 1.0;
  }
}
