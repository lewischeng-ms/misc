#include <deque>
#include <vector>
#include <iostream>
#include <iomanip>
#include <tuple>
#include <unordered_map>
#include <windows.h>

class Tape
{
public:
    Tape()
        : m_list(1, ' ')
    {
        m_iterator = m_list.begin();
    }

    Tape(const char *s)
    {
        while (*s)
            m_list.push_back(*s++);
        m_iterator = m_list.begin();
    }

    void Cut()
    {
        m_list.erase(m_list.begin(), m_iterator);
        m_iterator = m_list.begin();
    }

    char Read()
    {
        return *m_iterator;
    }

    void Write(char symbol)
    {
        *m_iterator = symbol;
    }

    void PrintLine()
    {
        int pos = 2;
        int j = 2;
        for (std::deque<char>::iterator i = m_list.begin(); i != m_list.end(); ++i)
        {
            std::cout << *i;
            if (m_iterator == i)
                pos = j;
            ++j;
        }
        std::cout << '\n' << std::setw(pos) << "^\n";
        ::Sleep(100);
    }

    void MoveLeft()
    {
        if (m_iterator == m_list.begin())
            m_iterator = m_list.insert(m_iterator, ' ');
        else
            --m_iterator;
    }

    void MoveRight()
    {
        if ((m_iterator + 1) == m_list.end())
            m_iterator = m_list.insert(m_list.end(), ' ');
        else
            ++m_iterator;
    }

private:
    std::deque<char> m_list;
    std::deque<char>::iterator m_iterator;
};

typedef std::tuple<int, char, char> Rule03;
typedef std::unordered_map<char, Rule03> Rule13;
typedef std::unordered_map<int, Rule13> Rule23;

class Controller
{
public:
    Controller()
    {

    }

    Controller(Controller &controller)
        : m_rules(controller.m_rules), m_state_final(controller.m_state_final)
    {

    }

    void AddRule(int state_from, char symbol_read, int state_to, char symbol_write, char direction)
    {
        Rule13 &rule13 = m_rules[state_from];
        Rule03 rule03(state_to, symbol_write, direction);
        rule13[symbol_read] = rule03;
    }

    void PrintRules()
    {
        std::cout << "Rules:\n";
        for (Rule23::iterator i = m_rules.begin(); i != m_rules.end(); ++i)
        {
            int state_from = i->first;

            Rule13 &rule13 = i->second;
            for (Rule13::iterator j = rule13.begin(); j != rule13.end(); ++j)
            {
                char symbol_read = j->first;

                Rule03 &rule03 = j->second;
                int state_to = std::get<0>(rule03);
                char symbol_write = std::get<1>(rule03);
                char direction = std::get<2>(rule03);
                std::cout << "(S" << state_from
                    << ", '" << symbol_read
                    << "') => (S" << state_to
                    << ", '" << symbol_write
                    << "', " << direction
                    << ")\n";
            }
        }

        std::cout << "\nFinal states:\n";
        for (std::unordered_map<int, bool>::iterator i = m_state_final.begin(); i != m_state_final.end(); ++i)
            if (i->second)
                std::cout << 'S' << i->first << ' ';
        std::cout << "\n\n";
    }

    void MarkFinal(int state)
    {
        m_state_final[state] = true;
    }

    void Run(Tape &tape, bool print_each_step = false)
    {
        if (print_each_step)
            tape.PrintLine();

        m_state = 0;
        while (!m_state_final[m_state])
        {
            Rule23::iterator i = m_rules.find(m_state);
            if (i == m_rules.end())
            {
                std::cerr << 'S' << m_state << " undefined.\n";
                break;
            }

            char symbol_read = tape.Read();
            Rule13 &rule13 = i->second;
            Rule13::iterator j = rule13.find(symbol_read);
            if (j == rule13.end())
            {
                std::cerr << "No rule for S" << m_state << " and '" << symbol_read << "'.\n";
                break;
            }

            Rule03 &rule03 = j->second;
            m_state = std::get<0>(rule03);

            char symbol_write = std::get<1>(rule03);
            tape.Write(symbol_write);

            char direction = std::get<2>(rule03);
            if (direction == 'L')
                tape.MoveLeft();
            else if (direction == 'R')
                tape.MoveRight();

            if (print_each_step)
                tape.PrintLine();
        }
    }

private:
    Rule23 m_rules;
    std::unordered_map<int, bool> m_state_final;
    int m_state;
};

// 打印交错01串
void ZeroOneString(Tape &t)
{
    Controller c;

    c.AddRule(0, ' ', 1, '0', 'R');
    c.AddRule(1, ' ', 0, '1', 'R');

    c.Run(t, true);
}

// 计数
void Counter(Tape &t)
{
    Controller c;

    c.AddRule(0, '0', 0, '0', 'R');
    c.AddRule(0, '1', 0, '1', 'R');
    c.AddRule(0, ' ', 1, ' ', 'L');
    c.AddRule(1, '0', 0, '1', 'R');
    c.AddRule(1, '1', 1, '0', 'L');
    c.AddRule(1, ' ', 0, '1', 'R');

    c.Run(t, true);
}

// 按位取反
void BitwiseFlip(Tape &t)
{
    Controller c;

    // 如果这里看到的是0，那么S1将写1；
    // 如果这里看到的是1，那么S2将写0。
    c.AddRule(0, '0', 1, ' ', 'R');
    c.AddRule(0, '1', 2, ' ', 'R');
    c.AddRule(0, '$', 4, '$', 'S');

    c.AddRule(1, '0', 1, '0', 'R');
    c.AddRule(1, '1', 1, '1', 'R');
    c.AddRule(1, ' ', 3, '1', 'L');
    c.AddRule(1, '$', 1, '$', 'R');

    c.AddRule(2, '0', 2, '0', 'R');
    c.AddRule(2, '1', 2, '1', 'R');
    c.AddRule(2, ' ', 3, '0', 'L');
    c.AddRule(2, '$', 2, '$', 'R');

    // 往回移到数字开头。
    c.AddRule(3, '0', 3, '0', 'L');
    c.AddRule(3, '1', 3, '1', 'L');
    c.AddRule(3, ' ', 0, ' ', 'R');
    c.AddRule(3, '$', 3, '$', 'L');

    c.MarkFinal(4);

    c.Run(t, true);
}

// a<=b?
// 必须同等长度
void Less(Tape &t)
{
    Controller c;

    // 若第一位为0，则去(a)
    // 若第一位为1，则去(b)
    c.AddRule(0, '0', 1, ' ', 'R');
    c.AddRule(0, '1', 4, ' ', 'R');
    c.AddRule(0, '$', 6, ' ', 'R'); // 等于最后也写0

    // (a) 若0，把第二个数的第一位改成$；若1，则确定小于
    c.AddRule(1, '0', 1, '0', 'R');
    c.AddRule(1, '1', 1, '1', 'R');
    c.AddRule(1, '$', 2, '$', 'R');
    c.AddRule(2, '$', 2, '$', 'R');
    c.AddRule(2, '0', 3, '$', 'L');
    c.AddRule(2, '1', 9, ' ', 'R');

    // 移回第一个数开头。
    c.AddRule(3, '0', 3, '0', 'L');
    c.AddRule(3, '1', 3, '1', 'L');
    c.AddRule(3, '$', 3, '$', 'L');
    c.AddRule(3, ' ', 0, ' ', 'R');

    // (b) 如果第二个数的第一位是1继续比较；如果是0，那确定大于
    c.AddRule(4, '0', 4, '0', 'R');
    c.AddRule(4, '1', 4, '1', 'R');
    c.AddRule(4, '$', 5, '$', 'R');
    c.AddRule(5, '$', 5, '$', 'R');
    c.AddRule(5, '0', 6, ' ', 'R');
    c.AddRule(5, '1', 3, '$', 'L');

    // 最后写0
    c.AddRule(6, '0', 6, ' ', 'R');
    c.AddRule(6, '1', 6, ' ', 'R');
    c.AddRule(6, '$', 6, ' ', 'R');
    c.AddRule(6, ' ', 7, '0', 'R');

    // 最后写1
    c.AddRule(9, '0', 9, ' ', 'R');
    c.AddRule(9, '1', 9, ' ', 'R');
    c.AddRule(9, '$', 9, ' ', 'R');
    c.AddRule(9, ' ', 7, '1', 'R');

    //c.AddRule(7, ' ', 8, '$', 'L');
    c.MarkFinal(7);

    c.Run(t, true);
}

int main(int argc, char* argv[])
{
//    Tape t;
//    ZeroOneString(t);
//    Counter(t);

    Tape t("0010010$");
    BitwiseFlip(t);

/*
    Tape t("00111011$00111010$");
    Less(t);
    t.Cut();
    t.PrintLine(); */

    return 0;
}

