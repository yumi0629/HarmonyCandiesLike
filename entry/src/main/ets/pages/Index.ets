import { LikeButton } from '../component/LikeButton'

@Entry
@Component
struct Index {
  build() {
    Stack({}) {
      LikeButton().width('50%').height('50%')
    }
    .width('100%')
    .height('100%')
  }
}