export function degToRad(deg: number) {
  return deg * (Math.PI / 180.0)
}

export function radToDeg(rad: number) {
  return rad * (180.0 / Math.PI)
}

export function clamp(value: number, low: number, high: number) {
  return Math.min(Math.max(value, low), high)
}

export function mapValueFromRangeToRange(value: number, fromLow: number, fromHigh: number, toLow: number, toHigh: number) {
  return toLow + ((value - fromLow) / (fromHigh - fromLow) * (toHigh - toLow));
}

/**
 * 返回颜色格式："#xxxxxxxx"
 * @param a rgba颜色，格式："#xxxxxxxx"
 * @param b rgba颜色，格式："#xxxxxxxx"
 * @param t alpha透明度，范围：[0.0~1.0]
 */
export function lerpColors(a: string, b: string, t: number) {
  if (b == null) {
    if (a == null) {
      return null;
    } else {
      return _scaleAlpha(a, 1.0 - t);
    }
  } else {
    if (a == null) {
      return _scaleAlpha(b, t);
    } else {
      var alpha = clamp(_lerpInt(_parseInt(a.slice(1, 3)), _parseInt(b.slice(1, 3)), t), 0, 255)
      var red = clamp(_lerpInt(_parseInt(a.slice(3, 5)), _parseInt(b.slice(3, 5)), t), 0, 255)
      var green = clamp(_lerpInt(_parseInt(a.slice(5, 7)), _parseInt(b.slice(5, 7)), t), 0, 255)
      var blue = clamp(_lerpInt(_parseInt(a.slice(7, 9)), _parseInt(b.slice(7, 9)), t), 0, 255)
      return `#${_roundTo16(alpha)}${_roundTo16(red)}${_roundTo16(green)}${_roundTo16(blue)}`
    }
  }
}

export function lerpColorsWithAlpha(a: string, b: string, t: number, alpha: number) {
  var color = lerpColors(a, b, t)
  return `#${_roundTo16(alpha)}${color.slice(3, 9)}`
}

function _roundTo16(n: number) {
  return Math.round(n).toString(16).padStart(2, '0')
}

function _parseInt(a: string) {
  return parseInt(`0x${a}}`)
}

function _lerpInt(a: number, b: number, t: number) {
  return a + (b - a) * t
}

function _scaleAlpha(a: string, factor: number) {
  var alpha = parseInt(a.slice(1, 3)) * factor
  var alpha16 = clamp(alpha, 0, 255).toString(16)
  return `#${alpha16}${a.substring(3, 9)}`
}
