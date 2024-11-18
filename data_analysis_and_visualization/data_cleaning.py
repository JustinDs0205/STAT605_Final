import pandas as pd
import os
from concurrent.futures import ProcessPoolExecutor

# 文件夹路径，替换为您的文件夹路径
folder_path = '/Users/zdliu/Desktop/605_2024fall/Data'

# 定义处理单个 CSV 文件的函数
def process_csv(file_path):
    try:
        # 读取 CSV 文件
        df = pd.read_csv(file_path)
        
        # 删除 STATUS == -101 的行
        if 'STATUS' in df.columns:
            df = df[df['STATUS'] != -101]
        
        # 保存修改后的文件，覆盖原文件
        df.to_csv(file_path, index=False)
        print(f"Processed: {file_path}")
    except Exception as e:
        print(f"Error processing {file_path}: {e}")

# 获取文件夹中所有 CSV 文件的路径
csv_files = [os.path.join(folder_path, file) for file in os.listdir(folder_path) if file.endswith('.csv')]

# 使用并行处理来处理 CSV 文件
if __name__ == "__main__":
    with ProcessPoolExecutor() as executor:
        executor.map(process_csv, csv_files)

    print("所有文件处理完成！")