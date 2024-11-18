import pandas as pd

# 配置CSV文件路径和目标列名
csv_file_path = '/Users/zdliu/Desktop/605_2024fall/DOT_Traffic_Speeds_NBE.csv'
target_column = 'LINK_NAME'

# 使用pandas读取数据并提取目标列的唯一值
def extract_unique_values(csv_file_path, target_column):
    try:
        # 读取数据
        data = pd.read_csv(csv_file_path, usecols=[target_column])
        filtered_data = data[data[target_column].map(data[target_column].value_counts()) > 100]
        # 提取唯一值
        unique_values = filtered_data[target_column].unique()
        
        # 打印或返回唯一值
        print(f"Unique values in column '{target_column}':")
        print(unique_values)
        
        return unique_values
    except Exception as e:
        print(f"Error: {e}")

# 调用函数
extract_unique_values(csv_file_path, target_column)
