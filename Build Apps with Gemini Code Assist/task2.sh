
read -p "Enter Project ID: " PROJECT_ID

gcloud auth login

sudo apt update
sudo apt -y upgrade
sudo apt install -y python3-venv
python3 -m venv ~/env
source ~/env/bin/activate




# export PROJECT_ID=qwiklabs-gcp-00-8104e4c9c3c9
export BUCKET_NAME=$PROJECT_ID-code
gcloud storage cp -r gs://$BUCKET_NAME/* .

pip install -r requirements.txt

# python3 main.py




cat > ~/codeassist-demo/test_calendar.py <<'EOF'
import unittest
import calendar

class TestNumberToRoman(unittest.TestCase):

    def test_basic_conversions(self):
        self.assertEqual(calendar.number_to_roman(1), "I")
        self.assertEqual(calendar.number_to_roman(5), "V")
        self.assertEqual(calendar.number_to_roman(10), "X")
        self.assertEqual(calendar.number_to_roman(50), "L")
        self.assertEqual(calendar.number_to_roman(100), "C")
        self.assertEqual(calendar.number_to_roman(500), "D")
        self.assertEqual(calendar.number_to_roman(1000), "M")

    def test_combinations(self):
        self.assertEqual(calendar.number_to_roman(4), "IV")
        self.assertEqual(calendar.number_to_roman(9), "IX")
        self.assertEqual(calendar.number_to_roman(14), "XIV")
        self.assertEqual(calendar.number_to_roman(40), "XL")
        self.assertEqual(calendar.number_to_roman(90), "XC")
        self.assertEqual(calendar.number_to_roman(400), "CD")
        self.assertEqual(calendar.number_to_roman(900), "CM")
        self.assertEqual(calendar.number_to_roman(1994), "MCMXCIV")
        self.assertEqual(calendar.number_to_roman(3888), "MMMDCCCLXXXVIII")

    def test_edge_cases(self):
        self.assertEqual(calendar.number_to_roman(0), "") #  Should handle zero
        self.assertRaises(TypeError, calendar.number_to_roman, "abc") # Should handle invalid input

    def test_large_numbers(self):
        self.assertEqual(calendar.number_to_roman(3000), "MMM")
        self.assertEqual(calendar.number_to_roman(3999), "MMMCMXCIX")

if __name__ == '__main__':
    unittest.main()

EOF



cat > ~/codeassist-demo/calendar.py <<EOF
def number_to_roman(number):
    """Converts an integer to its Roman numeral equivalent.

    Args:
        number: An integer between 0 and 3999.

    Returns:
        A string representing the Roman numeral equivalent of the number.
        Returns an empty string if the input is 0.
        Raises TypeError if the input is not an integer or is out of range.
    """
    try:
        number = int(number)
    except ValueError:
        raise TypeError("Input must be an integer.")

    if not 0 <= number <= 3999:
        raise TypeError("Input must be between 0 and 3999.")

    if number == 0:
        return ""

    roman_map = { 1000: 'M', 900: 'CM', 500: 'D', 400: 'CD', 100: 'C', 90: 'XC',
                50: 'L', 40: 'XL', 10: 'X', 9: 'IX', 5: 'V', 4: 'IV', 1: 'I'}

    result = ""
    for value, numeral in roman_map.items():
        while number >= value:
            result += numeral
            number -= value
    return result
EOF
cd ~/codeassist-demo
python3 test_calendar.py

pip install -r requirements.txt

python3 test_calendar.py


cd templates

rm convert.html index.html

wget https://raw.githubusercontent.com/quiccklabs/Labs_solutions/refs/heads/master/Build%20Apps%20with%20Gemini%20Code%20Assist/convert.html

wget https://raw.githubusercontent.com/quiccklabs/Labs_solutions/refs/heads/master/Build%20Apps%20with%20Gemini%20Code%20Assist/index.html

cd ..

python3 main.py
