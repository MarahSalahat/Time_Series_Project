import joblib
import pandas as pd
from flask import Flask, jsonify, request

app = Flask(__name__)

if __name__ == "__main__":
    app.run(host='127.0.0.1', port=5000)


station_info = {
    1: {
        'model_max_path': r'C:\Users\marah salahat\Desktop\Prediction\Station1\S1Tmax.sav',
        'model_min_path': r'C:\Users\marah salahat\Desktop\Prediction\Station1\S1Tmin.sav',
        'csv_max_path': r'C:\Users\marah salahat\Desktop\Prediction\Station1\S1_max.xls',
        'csv_min_path': r'C:\Users\marah salahat\Desktop\Prediction\Station1\S1_min.xls'
    },
    2: {
        'model_max_path': r'C:\Users\marah salahat\Desktop\Prediction\Station2\S2Tmax.sav',
        'model_min_path': r'C:\Users\marah salahat\Desktop\Prediction\Station2\S2Tmin.sav',
        'csv_max_path': r'C:\Users\marah salahat\Desktop\Prediction\Station2\S2_max.xls',
        'csv_min_path': r'C:\Users\marah salahat\Desktop\Prediction\Station2\S2_min.xls'
    },

    3: {
        'model_max_path': r'C:\Users\marah salahat\Desktop\Prediction\Station3\S3_Tmax.sav',
        'model_min_path': r'C:\Users\marah salahat\Desktop\Prediction\Station3\S3_Tmin.sav',
        'csv_max_path': r'C:\Users\marah salahat\Desktop\Prediction\Station3\S3_max.xls',
        'csv_min_path': r'C:\Users\marah salahat\Desktop\Prediction\Station3\S3_min.xls'
    },

    4: {
        'model_max_path': r'C:\Users\marah salahat\Desktop\Prediction\Station4\S4Tmax.sav',
        'model_min_path': r'C:\Users\marah salahat\Desktop\Prediction\Station4\S4Tmin.sav',
        'csv_max_path': r'C:\Users\marah salahat\Desktop\Prediction\Station4\S4_max.xls',
        'csv_min_path': r'C:\Users\marah salahat\Desktop\Prediction\Station4\S4_min.xls'
    },

    5: {
        'model_max_path': r'C:\Users\marah salahat\Desktop\Prediction\Station5\S5Tmax.sav',
        'model_min_path': r'C:\Users\marah salahat\Desktop\Prediction\Station5\S5Tmin.sav',
        'csv_max_path': r'C:\Users\marah salahat\Desktop\Prediction\Station5\S5_max.xls',
        'csv_min_path': r'C:\Users\marah salahat\Desktop\Prediction\Station5\S5_min.xls'
    },
    
}

def load_model_and_csv(station_number):
    station_data = station_info.get(station_number)
    if station_data:
        model_max = joblib.load(station_data['model_max_path'])
        model_min = joblib.load(station_data['model_min_path'])
        df_max = pd.read_csv(station_data['csv_max_path'])
        df_min = pd.read_csv(station_data['csv_min_path'])
        return model_max, model_min, df_max, df_min
    else:
        raise ValueError(f"Station {station_number} not found.")

@app.route("/pred", methods=['POST'])
def predict():
    try:
        request_data = request.get_json()
        station_number = request_data.get('station_number')  
        if not station_number:
            return jsonify({"error": "Station number not provided in the request."}), 400
        
        model_max, model_min, df_max, df_min = load_model_and_csv(station_number)

        
        predictions = {}

        for i in range(5):
            temperature_values = df_max["Present_Tmax"].tail(10).values
            prediction = model_max.predict([temperature_values])
            new_row = pd.DataFrame({"Present_Tmax": [round(prediction[0], 2)]})
            df_max = pd.concat([df_max, new_row], ignore_index=True)
            predictions[i]=round(prediction[0], 2) 

        

        for i in range(5,10):
            temperature_values = df_min["Present_Tmin"].tail(10).values
            prediction = model_min.predict([temperature_values])
            new_row = pd.DataFrame({"Present_Tmin": [round(prediction[0], 2)]})
            df_min = pd.concat([df_min, new_row], ignore_index=True)
            predictions[i]=round(prediction[0], 2) 

        
        

        response = {
            "predict": predictions
        }

        return jsonify(response)

    except Exception as e:
        return jsonify({"error": str(e)}), 500


