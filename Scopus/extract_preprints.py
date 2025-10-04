#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import re
import csv

def extract_preprints_to_csv(input_file, output_file):
    """
    プレプリント一覧.mdからCSV形式でデータを抽出（最終版）
    """
    
    # ファイル読み込み
    with open(input_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # 区切り文字で分割（＝が16個のセクション区切り）
    sections = content.split('＝' * 16)
    records = []
    
    for i, section in enumerate(sections):
        section = section.strip()
        if not section:
            continue
            
        lines = [line.strip() for line in section.split('\n') if line.strip()]
        
        # レコード番号を探す（• 付きまたは数字のみ）
        record_num = None
        record_line_idx = -1
        for j, line in enumerate(lines):
            # パターン1: "• 123"
            if line.startswith('•') and len(line.split()) == 2 and line.split()[1].isdigit():
                record_num = line.split()[1]
                record_line_idx = j
                break
            # パターン2: "123" （数字のみの行）
            elif line.isdigit():
                record_num = line
                record_line_idx = j
                break
        
        if not record_num:
            continue
            
        # 各要素を抽出
        try:
            # "Preprint • Open Access"の位置を探す
            preprint_idx = -1
            for j, line in enumerate(lines):
                if "Preprint" in line and "Open Access" in line:
                    preprint_idx = j
                    break
            
            if preprint_idx == -1:
                continue
                
            # タイトルと著者を取得
            title = lines[preprint_idx + 1] if preprint_idx + 1 < len(lines) else ""
            
            # 著者行を探す（複数行にまたがる可能性あり）
            authors_lines = []
            j = preprint_idx + 2
            while j < len(lines):
                line = lines[j]
                if line.startswith("Repository:"):
                    break
                # コンマや改行で分割された著者名
                if any(c in line for c in [',', '.']) or j == preprint_idx + 2:
                    authors_lines.append(line)
                else:
                    break
                j += 1
            
            authors = " ".join(authors_lines).strip()
            # 余分な改行や空白を除去
            authors = re.sub(r'\s+', ' ', authors)
            
            # Repository行を探す
            repository_line = ""
            abstract_start = -1
            for j, line in enumerate(lines):
                if line.startswith("Repository:"):
                    repository_line = line
                elif line == "抄録を非表示":
                    abstract_start = j + 1
                    break
            
            # Repository情報を分解
            if repository_line:
                # "Repository: Arxiv, 2025" -> preprint_name="Arxiv", year="2025"
                repo_match = re.search(r'Repository:\s*([^,]+),\s*(\d+)', repository_line)
                if repo_match:
                    preprint_name = repo_match.group(1).strip()
                    year = repo_match.group(2).strip()
                else:
                    preprint_name = repository_line.replace("Repository:", "").strip()
                    year = "Unknown"
            else:
                preprint_name = "Unknown"
                year = "Unknown"
            
            # 抄録を抽出
            abstract = ""
            if abstract_start > 0:
                abstract_lines = []
                for j in range(abstract_start, len(lines)):
                    line = lines[j]
                    if line == "。" or line == "関連文献":
                        break
                    abstract_lines.append(line)
                abstract = " ".join(abstract_lines).strip()
            
            if title and authors:  # 最低限タイトルと著者があるレコードのみ
                records.append([record_num, authors, title, year, preprint_name, abstract])
                print(f"レコード {record_num} を抽出: {title[:50]}...")
                
        except Exception as e:
            print(f"レコード {record_num} の処理中にエラー: {e}")
            continue
    
    # CSVファイル作成
    with open(output_file, 'w', newline='', encoding='utf-8') as csvfile:
        writer = csv.writer(csvfile)
        
        # ヘッダー行
        writer.writerow(['number of record', 'Authors', 'Title', 'Year', 'name of the preprint', 'abstract'])
        
        # データ行（レコード番号順にソート）
        records.sort(key=lambda x: int(x[0]))
        for record in records:
            writer.writerow(record)
    
    print(f"抽出されたレコード数: {len(records)}")
    print(f"CSVファイルを作成しました: {output_file}")
    return len(records)

if __name__ == "__main__":
    input_file = "プレプリント一覧.md"
    output_file = "preprints_complete.csv"
    
    try:
        record_count = extract_preprints_to_csv(input_file, output_file)
        print(f"処理完了: {record_count} レコード抽出")
    except Exception as e:
        print(f"エラーが発生しました: {e}")