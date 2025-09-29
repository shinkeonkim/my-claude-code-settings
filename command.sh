#!/bin/bash

# Claude Code 설정 파일 이동 스크립트
echo "=== Claude Code 설정 파일 이동 스크립트 ==="
echo ""

# 현재 디렉토리 확인
CURRENT_DIR=$(pwd)
echo "현재 디렉토리: $CURRENT_DIR"
echo ""

# 대상 디렉토리 선택
echo "설정 파일을 어디로 이동하시겠습니까?"
echo "1) 현재 디렉토리 ($CURRENT_DIR)"
echo "2) 다른 디렉토리 지정"
echo ""
read -p "선택하세요 (1 또는 2): " choice

case $choice in
    1)
        TARGET_DIR="$CURRENT_DIR"
        ;;
    2)
        read -p "대상 디렉토리 경로를 입력하세요: " custom_dir
        # 경로 확장 (~ 처리)
        TARGET_DIR=$(eval echo "$custom_dir")

        # 디렉토리 존재 확인
        if [ ! -d "$TARGET_DIR" ]; then
            echo "오류: 디렉토리 '$TARGET_DIR'가 존재하지 않습니다."
            read -p "디렉토리를 생성하시겠습니까? (y/n): " create_dir
            if [ "$create_dir" = "y" ] || [ "$create_dir" = "Y" ]; then
                mkdir -p "$TARGET_DIR"
                echo "디렉토리 '$TARGET_DIR'를 생성했습니다."
            else
                echo "스크립트를 종료합니다."
                exit 1
            fi
        fi
        ;;
    *)
        echo "잘못된 선택입니다. 스크립트를 종료합니다."
        exit 1
        ;;
esac

echo ""
echo "대상 디렉토리: $TARGET_DIR"
echo ""

# 파일 복사 함수
copy_files() {
    local source="$1"
    local dest="$2"

    if [ -e "$source" ]; then
        echo "복사 중: $source -> $dest"
        cp -r "$source" "$dest"
        return 0
    else
        echo "파일/디렉토리가 존재하지 않음: $source"
        return 1
    fi
}

# 소스 디렉토리 설정
SOURCE_DIR="$HOME/my-claude-code-settings"

# 복사할 파일들 확인 및 복사
echo "파일 복사를 시작합니다..."
echo "소스 디렉토리: $SOURCE_DIR"
echo ""

copied_count=0

# .claude 디렉토리 복사
if copy_files "$SOURCE_DIR/.claude" "$TARGET_DIR/"; then
    ((copied_count++))
fi

# .mcp.json 파일 복사
if copy_files "$SOURCE_DIR/.mcp.json" "$TARGET_DIR/"; then
    ((copied_count++))
fi

echo ""
echo "=== 복사 완료 ==="
echo "총 $copied_count개 항목이 복사되었습니다."
echo "대상 위치: $TARGET_DIR"

# 복사된 파일 목록 확인
echo ""
echo "복사된 파일/디렉토리 목록:"
if [ -d "$TARGET_DIR/.claude" ]; then
    echo "✓ .claude/ (디렉토리)"
    ls -la "$TARGET_DIR/.claude/" | head -5
    if [ $(ls -1 "$TARGET_DIR/.claude/" | wc -l) -gt 5 ]; then
        echo "  ... (더 많은 파일이 있습니다)"
    fi
fi

if [ -f "$TARGET_DIR/.mcp.json" ]; then
    echo "✓ .mcp.json (파일)"
fi

echo ""
echo "스크립트 완료!"