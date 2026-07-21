#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG="Debug"
DEST_PLATFORM="iphonesimulator"

PODS=(
    "Foundation/ZCCLogComponent"
    "Foundation/ZCCUIComponent"
    "Foundation/ZCCWebComponent"
    "Business/ZCCBaseAssetModule"
)

echo "📱 $CONFIG | $DEST_PLATFORM"
echo ""

# ZCCBaseAssetModule 需要 ZCCMediator 头文件（ZCCMediator 未编译为 framework）
# 创建 header map
HDRMAP="$SCRIPT_DIR/Business/ZCCBaseAssetModule/.hdrmap"
rm -rf "$HDRMAP"
mkdir -p "$HDRMAP/ZCCMediator"
find "$SCRIPT_DIR/Mediator/ZCCMediator/Classes" -name "*.h" | while read f; do
    ln -sf "$f" "$HDRMAP/ZCCMediator/$(basename "$f")"
done
echo "📁 Header map: $HDRMAP/ZCCMediator ($(ls "$HDRMAP/ZCCMediator" | wc -l | tr -d ' ') headers)"
echo ""

for POD_PATH in "${PODS[@]}"; do
    POD_NAME=$(basename "$POD_PATH")
    PROJ="$SCRIPT_DIR/$POD_PATH/${POD_NAME}.xcodeproj"
    FWK_NAME="${POD_NAME}.framework"

    echo "━━━ 🔨 $POD_NAME ━━━"
    xcodebuild -project "$PROJ" -scheme "$POD_NAME" \
        -configuration "$CONFIG" -sdk "$DEST_PLATFORM" \
        -destination "generic/platform=iOS Simulator" \
        -derivedDataPath "$SCRIPT_DIR/$POD_PATH/Derived" \
        BUILD_LIBRARY_FOR_DISTRIBUTION=YES SKIP_INSTALL=NO \
        2>&1 | grep -E "BUILD|error:" | tail -3

    FWK=$(find "$SCRIPT_DIR/$POD_PATH/Derived" -name "$FWK_NAME" -type d | head -1)
    if [ -z "$FWK" ]; then echo "   ❌ 未找到 $FWK_NAME"; exit 1; fi

    BINARY_DIR="$SCRIPT_DIR/$POD_PATH/Binary"
    rm -rf "$BINARY_DIR/$FWK_NAME"
    mkdir -p "$BINARY_DIR"
    cp -R "$FWK" "$BINARY_DIR/"
    echo "   ✅ $BINARY_DIR/$FWK_NAME"
    echo ""
done

rm -rf "$HDRMAP"
echo "========================================"
echo "✅ 全部编译完成"
echo "  source 模式: pod install"
echo "  binary 模式: USE_BINARY=1 pod install"
echo "========================================"
