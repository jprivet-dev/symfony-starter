<?php

namespace App\Form;

use App\Dto\PriceFormDto;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\NumberType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;

class PriceWorkaroundType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        $builder
            ->add('priceA', NumberType::class, [
                'input' => 'string',
                'label' => 'Price A — GreaterThanOrEqual(new BcMath\\Number("0.01"))',
            ])
            ->add('priceB', NumberType::class, [
                'input' => 'string',
                'label' => 'Price B — GreaterThanOrEqual("0.01")',
            ])
            ->add('priceC', NumberType::class, [
                'input' => 'string',
                'label' => 'Price C — GreaterThanOrEqual(0.01)',
            ])
            ->add('priceD', NumberType::class, [
                'input' => 'string',
                'label' => 'Price D — Range(min: 0, max: 1000)',
            ]);
    }

    public function configureOptions(OptionsResolver $resolver): void
    {
        $resolver->setDefaults(['data_class' => PriceFormDto::class]);
    }
}
